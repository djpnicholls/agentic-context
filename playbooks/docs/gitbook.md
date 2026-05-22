# Gitbook Documentation Generator

## Overview

Generate consistent API documentation. This playbook creates markdown guides and references that can be published to GitBook.

## What's Needed From User

- **Product name** (e.g., Stripe)
- **Product description** (2-3 paragraphs explaining what the product does)
- **API base URLs** (development and production)
- **Authentication method** (OAuth 2.0 with PKCE, API Key, JWT, etc.)
- **Authentication server URLs** (if using OAuth)
- **Available scopes/permissions** (if using OAuth)
- **Integration types and certification requirements** (what integrations are supported and their minimum requirements)
- **Key terminology** specific to the product domain
- **OpenAPI specification files** (if available, for API reference pages, if not available attempt to generate OpenAPI spec files based on the repository)
- **Webhook event types** (if the product supports webhooks)

## Procedure

1. Ask the user for all inputs listed in "What's Needed From User" and confirm them before creating any files
2. Review the reference documentation at https://docs.hos.accessacloud.com/to understand the exact format and style
3. Create a documentation output directory named `{product-name}-api-docs/`
4. Generate the landing page as `{product-name}.md` (e.g., `resdiary.md`) — NOT `README.md` — with:
5. Generate the Introduction guide as a folder with parent page content in `guides/introduction/README.md` and sub-pages alongside it:
    - `guides/introduction/README.md` — Welcome message, Terminology definitions relevant to the product, Data encryption standards (TLS 1.2+ recommendation), Token request example with curl command, Making a request example with curl command and sample response
    - `guides/introduction/errors.md` — Error codes, descriptions, and resolution steps. These should be taken from the repository itself.
7. Generate the Authentication guide as a folder with parent page content in `guides/authentication/README.md` based on the product's auth method:
    - For OAuth 2.0 with PKCE: Include Overview, Quick Start, Implementation Guide (Preparation, Authorization, Token Exchange, Token Management), Security Best Practices, and Error Handling. If possible should provide examples in C#, PHP and Python.
    - For API Key auth: Include simpler key-based authentication flow with security best practices
    - For JWT: Include JWT token generation and usage with security best practices
8. Generate Authentication sub-pages inside the `guides/authentication/` folder (alongside the `README.md`):
    - `guides/authentication/oauth-2-authorization-code-flow-w-pkce.md` (if OAuth)
    - `guides/authentication/app-installation-flow.md` (if applicable)
9. If the product supports webhooks, create `guides/webhooks.md` describing event types, payloads, security verification, and retry behaviour
10. If the product has specific API workflows, create a product-specific guide (e.g., `guides/consumer-api-guide.md`) explaining key workflows across endpoints
11. If OpenAPI specs are provided, create API reference pages in `api-references/` (one file per API, e.g., `consumer-api.yaml`, `data-extract-api.yaml`)
12. If no OpenAPI specs are provided, attempt to generate the API spec looking at the project.
13. Check each generated markdown file for remaining placeholder tokens and replace or remove them
14. Deliver the complete documentation set to the user and explain that these markdown files can be imported into GitBook via Git repo sync, with the folder structure mapping to the sidebar navigation

## Specifications

**Documentation Structure:**
```
{product-name}-api-docs/
├── {product-name}.md (Landing page — named after the product, NOT README.md)
├── SUMMARY.md
├── guides/
│   ├── introduction/
│   │   ├── README.md (Introduction parent page content)
│   │   ├── errors.md
│   │   ├── dates-and-times.md
│   │   └── paging.md
│   ├── authentication/
│   │   ├── README.md (Authentication parent page content)
│   │   ├── oauth-2-authorization-code-flow-w-pkce.md
│   │   └── app-installation-flow.md
│   ├── {product-specific-guide}.md (if applicable)
│   └── webhooks.md (if applicable)
└── api-references/
    ├── {api-1}.yaml
    └── {api-2}.yaml
```

**GitBook Folder Convention:** When a page has sub-pages, use a **folder** containing a `README.md` for the parent page content, with sub-page files as siblings inside the same folder. Do NOT create a `.md` file and a same-named directory at the same level (e.g., never create both `authentication.md` and `authentication/`).

**Required Placeholders to Replace:**
| Placeholder | Description | Example |
|-------------|-------------|--------|
| `{PRODUCT_NAME}` | Software product name | ResDiary |
| `{PRODUCT_DESCRIPTION}` | 2-3 paragraph product overview | Cloud-based restaurant reservation... |
| `{API_BASE_URL}` | API base URL | api.resdiary.com |
| `{DEV_AUTH_URL}` | Development auth server URL | auth.rdbranch.com |
| `{PROD_AUTH_URL}` | Production auth server URL | auth.resdiary.com |
| `{AuthEndpoint}` | Authentication endpoint path | Jwt/v2/Authenticate |
| `{TOKEN_VALIDITY}` | Token lifetime | 24hrs |
| `{REFRESH_WINDOW}` | Window before expiry for refresh | 5 minutes |
| `{SCOPES}` | Available OAuth scopes | consumer_api, data_extract_api |
| `{ExampleEndpoint}` | Example API endpoint | ConsumerApi/v1/Restaurant |
| `{INTEGRATION_TYPE_1}` | First integration category | Online booking processes |
| `{INTEGRATION_TYPE_2}` | Second integration category | Data Extraction |

**Style Requirements:**
- Professional, technical tone
- Include curl examples for all API calls
- Use JSON for request/response examples
- Use tables for parameters, error codes, and scopes
- Use blockquotes for tips, warnings, and best practices

**Deliverables:**
- Complete set of markdown files ready for GitBook
- All placeholders replaced with product-specific values
- Code examples tested and accurate

## Advice and Pointers

- Always include the TLS 1.2+ recommendation in the Data Encryption section
- For OAuth 2.0 documentation, include C# code samples for PKCE implementation. Also include examples in PHP and Python.
- Include comprehensive error handling and troubleshooting sections - these are critical for developer experience
- Security best practices must be included for all authentication methods, not just OAuth
- The landing page file must be named `{product-name}.md` (e.g., `resdiary.md`), not `README.md`. GitBook treats `README.md` as a special file, and using a product-specific name ensures the page appears correctly in the GitBook sidebar navigation.
- When a guide page has sub-pages (e.g., Authentication with OAuth flow and App Installation sub-pages), always use the GitBook folder-with-README convention: create a folder and place the parent page content in `README.md` inside that folder, with sub-pages as sibling files. Never create a standalone `.md` file alongside a same-named directory.

## Forbidden Actions

- Do not omit security best practices from authentication documentation
- Do not use placeholder values in the final deliverables - all must be replaced with actual product information
- Do not create documentation without first reviewing the reference format at the GitBook URL
- Do not create a `.md` file and a same-named directory at the same level (e.g., `authentication.md` alongside `authentication/`). Always use the GitBook folder-with-README convention: place parent page content in `{folder}/README.md` with sub-pages as siblings inside the folder.
- Do not name the landing page `README.md`. It must be named `{product-name}.md` to ensure correct display when imported into GitBook.
