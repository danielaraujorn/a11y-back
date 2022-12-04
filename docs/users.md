# Users

## Register a user

### POST - /api/v1/users/register

Content-Type: application/json

Required:

- Unauthenticated user
- Fields: ["email", "password"]

Body Params:

```json
{
  "email": "example@email.com",
  "password": "@Password123",
  "deficiencies": [
    {
      "name": "name",
      "description": "description"
    }
  ]
}
```

Response:

**- 201:**

```json
{
  "data": {
    "id": "a82a4a66-756a-40d8-9fc0-e0e040646c3a",
    "email": "example@email.com",
    "role": "admin",
    "updated_at": "2022-01-01T22:33:38",
    "inserted_at": "2022-01-01T22:33:38",
    "deficiencies": [
      {
        "id": "fb36d9c2-a503-4913-9075-d5684691d5d7",
        "name": "name",
        "description": "description"
      }
    ]
  }
}
```

## Log in user

### POST - /api/v1/users/log_in

Content-Type: application/json

Required:

- Unauthenticated user
- Fields: ["email", "password"]

Body Params:

```json
{
  "email": "example@email.com",
  "password": "@Password123"
}
```

Response:

**- 200:**

```json
{
  "data": {
    "email": "example@email.com",
    "id": "f6b7e32b-53f8-4ad8-8923-6266943bca6d",
    "inserted_at": "2022-01-05T02:00:32",
    "role": "admin",
    "updated_at": "2022-01-05T02:00:32"
  }
}
```

## User forgot password

### POST - /api/v1/users/reset_password

Content-Type: application/json

Required:

- Unauthenticated user
- Fields: ["email", "url"]

Body Params:

```json
{
  "email": "example@email.com",
  "url": "localhost:3000/recover-passoword"
}
```

Response:

**- 200:**

```json
{
  "data": {
    "messages": ["If the account exists, we've sent an email"]
  }
}
```

## Reset Password with a valid token send in email

### PATCH - /api/v1/users/reset_password/:token

Content-Type: application/json

Required:

- Unauthenticated user
- Fields: ["password", "password_confirmation"]

Body Params:

```json
{
  "new_password": "@NewPassword123",
  "new_password_confirmation": "@NewPassword123"
}
```

Response:

**- 200:**

```json
{
  "data": {
    "messages": ["Successfully reset password"]
  }
}
```

## Request User confirmation

### POST - /users/confirmation

Content-Type: application/json
Required:

- Fields: ["email"]

Body Params:

```json
{
  "email": "example@email.com"
}
```

Response:

**- 200:**

```json
{
  "data": {
    "messages": [
      "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."
    ]
  }
}
```

## User confirmation with token sent in user email

### GET - /users/confirmation/:token

Content-Type: application/json

Response:

**- 200:**

```json
{
  "data": {
    "messages": [
      "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."
    ]
  }
}
```

## Request to change user email (send a link to current user email to confirm this change)

### PATCH - /api/v1/users/settings/email

Content-Type: application/json

Cookies: \_accessibility_reporter_key

Required:

- Authenticated user
- Fields: ["email", "current_password"]

Body Params:

```json
{
  "email": "new@email.com",
  "current_password": "@Password123"
}
```

Response:

**- 200:**

```json
{
  "data": {
    "messages": [
      "A link to confirm your email change has been sent to the new address"
    ]
  }
}
```

## Change user password

### PATCH - /api/v1/users/settings/password

Content-Type: application/json

Cookies: \_accessibility_reporter_key

Required:

- Authenticated user
- Fields: ["current_password", "new_password", "new_password_confirmation"]

Body Params:

```json
{
  "current_password": "@Password123",
  "new_password": "@Password1234",
  "new_password_confirmation": "@Password1234"
}
```

Response:

**- 200:**

```json
{
  "data": {
    "messages": ["Password updated successfully"]
  }
}
```

## Confirm user email modification

### GET - /users/settings/email_confirmation/:token

Content-Type: application/json

Cookies: \_accessibility_reporter_key

Required:

- Authenticated user

Response:

**- 200:**

```json
{
  "data": {
    "messages": ["Email changed successfully"]
  }
}
```

## User log out

### DELETE - api/v1/users/log_out

Content-Type: application/json

Cookies: \_accessibility_reporter_key

Response:

**- 204:**
""

## Get list of users

### GET - /api/v1/users

Content-Type: application/json

Cookies: \_accessibility_reporter_key

Query Params:

```txt
offset - Offset Pagination
limit - Limit Pagination
inserted_at - Filter by inserted_at - datetime
inserted_at_start - Filter by inserted_at_start - datetime
inserted_at_end - Filter by inserted_at_end - datetime
sort - Sort Field - string - ["inserted_at", "asc"]
roles - array - ?roles[]=admin&roles[]=normal&roles[]=validator
email - string
```

Required:

- Authenticated user
- Admin user

Response:

**- 200:**

```json
{
  "data": {
    "users": [
      {
        "deficiencies": [],
        "email": "teste@email.com",
        "id": "182781cf-117e-47ad-bffe-95a8ce40fdc7",
        "inserted_at": "2022-01-01T00:36:04",
        "role": "admin",
        "updated_at": "2022-01-01T00:36:21"
      }
    ]
  }
}
```

## Get one user

### GET - /api/v1/users/:id

Content-Type: application/json

Cookies: \_accessibility_reporter_key

Required:

- Authenticated user
- Admin user

Response:

**- 200:**

```json
{
  "data": {
    "deficiencies": [],
    "email": "teste@email.com",
    "id": "182781cf-117e-47ad-bffe-95a8ce40fdc7",
    "inserted_at": "2022-01-01T00:36:04",
    "role": "admin",
    "updated_at": "2022-01-01T00:36:21"
  }
}
```

## Change user role

### GET - /api/v1/users/:id/role

Content-Type: application/json

Cookies: \_accessibility_reporter_key

Required:

- Authenticated user
- Admin user

Body Params:

```json
{
  "role": "validator"
}
```

Response:

**- 200:**

```json
{
  "data": {
    "email": "teste1234@email.com",
    "id": "5a392f4a-189c-4816-a764-25f586029d04",
    "inserted_at": "2022-01-06T00:48:48",
    "role": "validator",
    "updated_at": "2022-01-06T01:00:56"
  }
}
```
