# Places

## Get all places

### GET - /api/v1/places/

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
statuses - @statuses
mine - boolean
```

Response:

**- 200:**

```json
{
  "data": {
    "places": [
      {
        "description": "Nome do lugar",
        "id": "b2bc7dec-f69d-4d8a-b840-1fad34a4b13d",
        "image": {
          "file_name": "arquivo.jpeg",
          "updated_at": "2022-01-01T21:32:35"
        },
        "inserted_at": "2022-01-01T21:32:35",
        "latitude": 1.0,
        "longitude": 1.0,
        "status": "inProgress",
        "updated_at": "2022-01-01T21:32:35",
        "validator_comments": "Comentários do validador",
        "deficiencies": [
          "b77468f5-6630-4ce6-b1ee-085937c8e0de"
        ],
        "barrier_level": 1
      }
    ]
  }
}
```

## Get a place

### GET - /api/v1/places/:id

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
    "deficiencies": [
      "b77468f5-6630-4ce6-b1ee-085937c8e0de"
    ],
    "barrier_level": 1
  }
}
```

## Create a place

### POST - /api/v1/places

Content-Type: multipart/form-data

Cookies: \_accessibility_reporter_key

Body Params:

```txt
description="Nome lugar" - text - required
status="inProgress" - text - ["inProgress", "validated", "needChanges"] - required
latitude="1" - text - required
longitude="1" - text - required
validator_comments="Comentários do validador" - text - optional
image="arquivo .jpeg" - file - optional
barrier_level=1
```

Response:
**- 201:**

```json
{
  "data": {
    "description": "Nome do lugar",
    "id": "b2bc7dec-f69d-4d8a-b840-1fad34a4b13d",
    "image": {
      "file_name": "arquivo.jpeg",
      "updated_at": "2022-01-01T21:32:35"
    },
    "inserted_at": "2022-01-01T21:32:35",
    "latitude": 1.0,
    "longitude": 1.0,
    "status": "inProgress",
    "updated_at": "2022-01-01T21:32:35",
    "validator_comments": "Comentários do validador",
    "barrier_level": 1
  }
}
```

Restrições:

- validator_comments - apenas usuários com role `validator` podem escrever comentários, para outros usuários esse campo é retornado como `null`

## Update a place

### PATCH - /api/v1/places/:id

Content-Type: multipart/form-data

Cookies: \_accessibility_reporter_key

Body Params:

```txt
description="Nome lugar updated" - text - optional
status="inProgress" - text - optional
latitude="1" - text - optional
longitude="1" - text - optional
validator_comments="Comentários do validador 2" - text - optional
image="arquivo .jpeg" - file - optional
barrier_level=1
```

Response:

**- 200:**

```json
{
  "data": {
    "description": "Nome do lugar updated",
    "id": "b2bc7dec-f69d-4d8a-b840-1fad34a4b13d",
    "image": {
      "file_name": "arquivo.jpeg",
      "updated_at": "2022-01-01T21:32:35"
    },
    "inserted_at": "2022-01-01T21:32:35",
    "latitude": 1.0,
    "longitude": 1.0,
    "status": "inProgress",
    "updated_at": "2022-01-01T21:32:35",
    "validator_comments": "Comentários do validador 2",
    "barrier_level": 1
  }
}
```

## Delete a place

### DELETE - /api/v1/places/:id

Content-Type: application/json

Cookies: \_accessibility_reporter_key

Response:

**- 204:**

""
