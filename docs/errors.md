# Errors

## General Errors

Status: not_found / bad_request / unprocessable_entity / etc

Format:

```json
{
   "message": "general error message"
}
```

## Query / Body params Validation Errors

Status: unprocessable_entity

Format:

```json
{
    "message": "general error message",
    "details": [{
        "field1": "validation error message"
    },
    {
        "field2": "validation error message"
    }]
}
```
