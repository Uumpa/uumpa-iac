output "sonarqube" {
  value = {
    saml = {
      "Application ID": "https://sonarqube.${local.dns.root_domain}/saml",
      "SAML login url": "https://login.microsoftonline.com/${local.core.current_subscription.tenant_id}/saml2",
      "Provider ID": "https://sts.windows.net/${local.core.current_subscription.tenant_id}/",
      "SAML user login attribute": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress",
      "SAML user name attribute": "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname",
      "Identity provider certificate": "Get from Azure AD enterprise application SonarQube -> Single sign-on -> SAML Certificate (Base64)",
    }
    "azuredevops_token" = "bin/get_secret.py uumpaprod sonarqube-azdo-token"
  }
}
