data "azuread_application_template" "saml" {
  display_name = "Azure AD SAML Toolkit"
}

resource "azuread_application" "sq" {
  display_name = "SonarQube"
  template_id = data.azuread_application_template.saml.template_id
  identifier_uris = [
    "https://sonarqube.${local.dns.root_domain}/saml"
  ]
  web {
    redirect_uris = [
      "https://sonarqube.${local.dns.root_domain}/oauth2/callback/saml"
    ]
    implicit_grant {
      access_token_issuance_enabled = null
      id_token_issuance_enabled = null
    }
  }
}
