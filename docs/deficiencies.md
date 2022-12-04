# Deficiencies

## Get all deficiencies

### GET - /api/v1/deficiencies/

Content-Type: application/json

Query Params:

```txt
offset - Offset Pagination
limit - Limit Pagination
inserted_at - Filter by inserted_at - datetime
inserted_at_start - Filter by inserted_at_start - datetime
inserted_at_end - Filter by inserted_at_end - datetime
sort - Sort Field - string - ["inserted_at", "asc"]
ids - array - ?ids[]=uuid&ids[]=uuid
```

Response:
**- 200:**

```json
{
  "data": {
    "deficiencies": [
      {
        "id": "acefb453-4db9-473e-9a87-77054fba2d71",
        "name": "title",
        "description": "description",
        "inserted_at": "2022-01-01T20:57:36",
        "updated_at": "2022-01-01T20:57:36"
      }
    ]
  }
}
```

## Get a deficiency

### GET - /api/v1/deficiencies/:id

Content-Type: application/json

Cookies: \_accessibility_reporter_key

Response:

**- 200:**

```json
{
  "data": {
    "id": "acefb453-4db9-473e-9a87-77054fba2d71",
    "name": "title",
    "description": "description",
    "inserted_at": "2022-01-01T20:57:36",
    "updated_at": "2022-01-01T20:57:36",
    "place_id": "b07f6fea-9cfb-4b88-9c7d-df105b042f34"
  }
}
```

## Create a deficiency

### POST - /api/v1/deficiencies

Content-Type: application/json

Cookies: \_accessibility_reporter_key

Required:

- Fields: ["name", "description"]

Optional: 

- Fields: ["place_id"]

Body Params:

```json
{
  "name": "title",
  "description": "title",
  "place_id": "b07f6fea-9cfb-4b88-9c7d-df105b042f34"
}
```

Response:

**- 201:**

```json
{
  "data": {
    "id": "acefb453-4db9-473e-9a87-77054fba2d71",
    "name": "title",
    "description": "description",
    "inserted_at": "2022-01-01T20:57:36",
    "updated_at": "2022-01-01T20:57:36",
    "place_id": "b07f6fea-9cfb-4b88-9c7d-df105b042f34"
  }
}
```

## Update a deficiency

### PATCH - /api/v1/deficiencies/:id

Content-Type: application/json

Cookies: \_accessibility_reporter_key

Body Params:

```json
{
  "description": "description updated",
  "name": "title updated"
}
```

Response:
**- 200:**

```json
{
  "data": {
    "id": "acefb453-4db9-473e-9a87-77054fba2d71",
    "name": "title updated",
    "description": "description updated",
    "inserted_at": "2022-01-01T20:57:36",
    "updated_at": "2022-01-01T20:57:36",
    "place_id": "b07f6fea-9cfb-4b88-9c7d-df105b042f34"
  }
}
```

## Delete a deficiency

### DELETE - /api/v1/deficiencies/:id

Content-Type: application/json

Cookies: \_accessibility_reporter_key

Response:

**- 204:**

""
