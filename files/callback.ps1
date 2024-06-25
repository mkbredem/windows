# Bypass SSL/TLS certificate validation
Add-Type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

# Alternative method for newer PowerShell versions
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

# This is the code you should focus on for your callback 
# You will need to add in your vars for extra_vars and the host_config_key
$uri = "https://your.controller.com/api/v2/job_templates/<your job template>/callback/"
$headers = @{
    "Content-Type" = "application/json"
    "Authorization" = "Bearer <TOKEN>"
}
$body = @{
    extra_vars = @{
        target_hosts = @("all")
        test = "test2"
    }
} | ConvertTo-Json

Invoke-WebRequest -Uri $uri -Method Post -Headers $headers -Body $body -UseBasicParsing
