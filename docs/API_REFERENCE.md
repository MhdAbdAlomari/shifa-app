# Shifa API Reference

All endpoints are prefixed with `/api` and expect `Accept: application/json`. Protected endpoints require `Authorization: Bearer <token>`. All responses shown below were captured against a freshly seeded database (`php artisan migrate:fresh --seed`) — dates and IDs reflect what the seeder produces.

**Base URL:** `http://127.0.0.1:8000`

**Total routes:** 37

**Role model:** every user has `role ∈ {admin, coordinator, surgeon}`. Endpoints are gated by the `role:<name>` middleware ([app/Http/Middleware/EnsureRole.php](app/Http/Middleware/EnsureRole.php)). Attempting an endpoint with the wrong role returns:

```json
HTTP 403
{"message":"Forbidden. Requires role: <role>"}
```

Any authenticated endpoint hit without a token (or with an expired token) returns:

```json
HTTP 401
{"message":"Unauthenticated."}
```

Note on 404s: with `APP_DEBUG=true` (the default in development), 404s from route-model-binding include a stack trace. The shapes below show the response when `APP_DEBUG=false` (the way clients see it).

---

## Auth

### POST `/api/register`

Register a new user and return an API token.

**Access:** public.

**Body:**

| Field | Type | Required | Notes |
|---|---|---|---|
| `name` | string | yes | max 255 |
| `email` | string | yes | valid email, unique |
| `password` | string | yes | min 8, must include `password_confirmation` |
| `password_confirmation` | string | yes | must match `password` |
| `role` | string | yes | one of `admin`, `coordinator`, `surgeon` |
| `specialty` | string | conditional | required when `role=surgeon` |

**Example success (HTTP 201):**

```json
{
  "user": {
    "id": 8,
    "name": "New Coord",
    "email": "newcoord@shifa.test",
    "role": "coordinator",
    "specialty": null,
    "created_at": "2026-09-04T20:34:56.000000Z"
  },
  "token": "1|gSOHXpcPuSe3KogJDZRATNuCJqNVES8xK6ZQbQjP094b16f7"
}
```

**Validation failure (HTTP 422):**

```json
{
  "message": "The name field is required. (and 4 more errors)",
  "errors": {
    "name": ["The name field is required."],
    "email": ["The email field must be a valid email address."],
    "password": [
      "The password field confirmation does not match.",
      "The password field must be at least 8 characters."
    ],
    "role": ["The role field is required."]
  }
}
```

---

### POST `/api/login`

Exchange credentials for a token.

**Access:** public.

**Body:**

| Field | Type | Required |
|---|---|---|
| `email` | string | yes |
| `password` | string | yes |

**Example success (HTTP 200):**

```json
{
  "user": {
    "id": 1,
    "name": "Admin User",
    "email": "admin@shifa.test",
    "role": "admin",
    "specialty": null,
    "created_at": "2026-09-04T20:34:46.000000Z"
  },
  "token": "2|bdcwyRf2m9Zc6HBvgOg3Y9eF6U8STjczn9us8xYD73f04ec5"
}
```

**Bad credentials (HTTP 422):**

```json
{
  "message": "The provided credentials are incorrect.",
  "errors": {
    "email": ["The provided credentials are incorrect."]
  }
}
```

---

### POST `/api/logout`

Revoke the current bearer token.

**Access:** any authenticated user.

**Body:** no body.

**Example success (HTTP 200):**

```json
{"message": "Logged out"}
```

Subsequent calls with the revoked token return `HTTP 401 {"message":"Unauthenticated."}`.

---

### GET `/api/me`

Return the currently authenticated user.

**Access:** any authenticated user.

**Body:** no body.

**Example success (HTTP 200):**

```json
{
  "user": {
    "id": 1,
    "name": "Admin User",
    "email": "admin@shifa.test",
    "role": "admin",
    "specialty": null,
    "created_at": "2026-09-04T20:32:06.000000Z"
  }
}
```

**Unauthenticated (HTTP 401):**

```json
{"message": "Unauthenticated."}
```

---

## Admin

All endpoints in this section require `role=admin`. Requests from other roles return `HTTP 403 {"message":"Forbidden. Requires role: admin"}`.

### GET `/api/rooms`

List all operating rooms, ordered by name.

**Body:** no body.

**Example success (HTTP 200):**

```json
{
  "data": [
    {"id": 1, "name": "OR-1", "status": "free", "supported_specialty": "Cardiology", "created_at": "2026-09-04T20:32:09.000000Z", "updated_at": "2026-09-04T20:32:09.000000Z"},
    {"id": 2, "name": "OR-2", "status": "free", "supported_specialty": "Orthopedics", "created_at": "2026-09-04T20:32:09.000000Z", "updated_at": "2026-09-04T20:32:09.000000Z"},
    {"id": 3, "name": "OR-3", "status": "free", "supported_specialty": "Neurology", "created_at": "2026-09-04T20:32:09.000000Z", "updated_at": "2026-09-04T20:32:09.000000Z"},
    {"id": 4, "name": "OR-4", "status": "free", "supported_specialty": "General", "created_at": "2026-09-04T20:32:09.000000Z", "updated_at": "2026-09-04T20:32:09.000000Z"},
    {"id": 5, "name": "OR-5", "status": "free", "supported_specialty": null, "created_at": "2026-09-04T20:32:09.000000Z", "updated_at": "2026-09-04T20:32:09.000000Z"}
  ]
}
```

---

### GET `/api/rooms/{room}`

Show a single room.

**Body:** no body.

**Example success (HTTP 200):**

```json
{
  "data": {
    "id": 1,
    "name": "OR-1",
    "status": "free",
    "supported_specialty": "Cardiology",
    "created_at": "2026-09-04T20:32:09.000000Z",
    "updated_at": "2026-09-04T20:32:09.000000Z"
  }
}
```

**Not found (HTTP 404):**

```json
{"message": "No query results for model [App\\Models\\OperatingRoom] 9999"}
```

---

### POST `/api/rooms`

Create a room.

**Body:**

| Field | Type | Required | Notes |
|---|---|---|---|
| `name` | string | yes | max 255 |
| `status` | string | no | one of `free`, `preparing`, `in_use`, `cleaning` |
| `supported_specialty` | string \| null | no | max 255 |

**Example success (HTTP 201):**

```json
{
  "data": {
    "id": 6,
    "name": "OR-Probe",
    "status": null,
    "supported_specialty": "General",
    "created_at": "2026-09-04T20:33:21.000000Z",
    "updated_at": "2026-09-04T20:33:21.000000Z"
  }
}
```

Note: `status` is `null` here because the request did not supply it — the DB default (`free`) is only applied when the column is entirely omitted at the SQL level. Prefer sending `status: "free"` explicitly.

**Validation failure (HTTP 422):**

```json
{
  "message": "The name field is required.",
  "errors": {"name": ["The name field is required."]}
}
```

**Wrong role (HTTP 403):**

```json
{"message": "Forbidden. Requires role: admin"}
```

---

### PUT `/api/rooms/{room}` · PATCH `/api/rooms/{room}`

Update a room. All fields optional (`sometimes`).

**Body:**

| Field | Type | Notes |
|---|---|---|
| `name` | string | max 255 |
| `status` | string | one of `free`, `preparing`, `in_use`, `cleaning` |
| `supported_specialty` | string \| null | max 255 |

**Example success (HTTP 200):**

```json
{
  "data": {
    "id": 6,
    "name": "OR-Probe",
    "status": "preparing",
    "supported_specialty": "General",
    "created_at": "2026-09-04T20:33:21.000000Z",
    "updated_at": "2026-09-04T20:33:22.000000Z"
  }
}
```

---

### DELETE `/api/rooms/{room}`

Hard-delete a room.

**Body:** no body.

**Example success (HTTP 200):**

```json
{"message": "Room deleted"}
```

---

### GET `/api/staff`

List all users whose role is `coordinator` or `surgeon` (admins are excluded), ordered by name.

**Body:** no body.

**Example success (HTTP 200):**

```json
{
  "data": [
    {"id": 2, "name": "Coordinator One", "email": "coord1@shifa.test", "role": "coordinator", "specialty": null, "created_at": "2026-09-04T20:32:07.000000Z"},
    {"id": 3, "name": "Coordinator Two", "email": "coord2@shifa.test", "role": "coordinator", "specialty": null, "created_at": "2026-09-04T20:32:07.000000Z"},
    {"id": 6, "name": "Dr. Baumbach", "email": "surgeon3@shifa.test", "role": "surgeon", "specialty": "Neurology", "created_at": "2026-09-04T20:32:09.000000Z"},
    {"id": 7, "name": "Dr. Dach", "email": "surgeon4@shifa.test", "role": "surgeon", "specialty": "General", "created_at": "2026-09-04T20:32:09.000000Z"},
    {"id": 5, "name": "Dr. Prohaska", "email": "surgeon2@shifa.test", "role": "surgeon", "specialty": "Orthopedics", "created_at": "2026-09-04T20:32:08.000000Z"},
    {"id": 4, "name": "Dr. Ziemann", "email": "surgeon1@shifa.test", "role": "surgeon", "specialty": "Cardiology", "created_at": "2026-09-04T20:32:08.000000Z"}
  ]
}
```

---

### GET `/api/staff/{staff}`

Show a single user by ID (any user, not filtered by role — the URL is called `staff` but it hits the underlying `users` table).

**Example success (HTTP 200):**

```json
{
  "data": {
    "id": 2,
    "name": "Coordinator One",
    "email": "coord1@shifa.test",
    "role": "coordinator",
    "specialty": null,
    "created_at": "2026-09-04T20:32:07.000000Z"
  }
}
```

---

### POST `/api/staff`

Create a coordinator or surgeon (admins cannot be created through this endpoint).

**Body:**

| Field | Type | Required | Notes |
|---|---|---|---|
| `name` | string | yes | max 255 |
| `email` | string | yes | valid email, unique |
| `password` | string | yes | min 8 |
| `role` | string | yes | one of `coordinator`, `surgeon` |
| `specialty` | string \| null | conditional | required when `role=surgeon` |

**Example success (HTTP 201):**

```json
{
  "data": {
    "id": 8,
    "name": "Probe Surgeon",
    "email": "probe.surg@shifa.test",
    "role": "surgeon",
    "specialty": "General",
    "created_at": "2026-09-04T20:33:27.000000Z"
  }
}
```

---

### PUT `/api/staff/{staff}` · PATCH `/api/staff/{staff}`

Update a user. All fields optional.

**Body:**

| Field | Type | Notes |
|---|---|---|
| `name` | string | max 255 |
| `email` | string | unique (ignoring current record) |
| `password` | string | min 8, re-hashed |
| `role` | string | one of `coordinator`, `surgeon` |
| `specialty` | string \| null | |

**Example success (HTTP 200):**

```json
{
  "data": {
    "id": 2,
    "name": "Coordinator One Renamed",
    "email": "coord1@shifa.test",
    "role": "coordinator",
    "specialty": null,
    "created_at": "2026-09-04T20:32:07.000000Z"
  }
}
```

---

### DELETE `/api/staff/{staff}`

Hard-delete a user. If the user has FK-referenced rows (e.g. surgeries where they are the surgeon or the creator) the underlying DB will reject the delete with an SQL constraint error.

**Example success (HTTP 200):**

```json
{"message": "Staff deleted"}
```

---

### GET `/api/dashboard/stats`

Return dashboard counters for the admin overview.

**Body:** no body.

**Example success (HTTP 200):**

```json
{
  "surgeries_today": 2,
  "rooms_in_use": 0,
  "total_rooms": 5,
  "surgeries_this_week": 5,
  "surgeries_completed_today": 0,
  "surgeries_in_progress": 1
}
```

**Wrong role (HTTP 403):**

```json
{"message": "Forbidden. Requires role: admin"}
```

---

## Coordinator

All endpoints in this section require `role=coordinator`. Requests from other roles return `HTTP 403 {"message":"Forbidden. Requires role: coordinator"}`.

### GET `/api/patients`

List all patients ordered by name.

**Body:** no body.

**Example success (HTTP 200):** (truncated to 3 rows for brevity — the actual response includes all 10 seeded patients)

```json
{
  "data": [
    {"id": 5, "name": "Bryon Hauck", "mrn": "MRN-00005", "medical_notes": null, "created_at": "2026-09-04T20:32:10.000000Z", "updated_at": "2026-09-04T20:32:10.000000Z"},
    {"id": 2, "name": "Cleve White", "mrn": "MRN-00002", "medical_notes": "Voluptatum consectetur ipsum doloremque a soluta provident blanditiis dicta.", "created_at": "2026-09-04T20:32:10.000000Z", "updated_at": "2026-09-04T20:32:10.000000Z"},
    {"id": 4, "name": "Dayna Roob III", "mrn": "MRN-00004", "medical_notes": null, "created_at": "2026-09-04T20:32:10.000000Z", "updated_at": "2026-09-04T20:32:10.000000Z"}
  ]
}
```

---

### GET `/api/patients/{patient}`

Show a single patient.

**Example success (HTTP 200):**

```json
{
  "data": {
    "id": 1,
    "name": "Kelton King",
    "mrn": "MRN-00001",
    "medical_notes": null,
    "created_at": "2026-09-04T20:32:10.000000Z",
    "updated_at": "2026-09-04T20:32:10.000000Z"
  }
}
```

---

### POST `/api/patients`

Create a patient.

**Body:**

| Field | Type | Required | Notes |
|---|---|---|---|
| `name` | string | yes | max 255 |
| `mrn` | string | yes | max 50, unique |
| `medical_notes` | string \| null | no | free text |

**Example success (HTTP 201):**

```json
{
  "data": {
    "id": 11,
    "name": "Probe Patient",
    "mrn": "MRN-PRB01",
    "medical_notes": "Test notes",
    "created_at": "2026-09-04T20:33:32.000000Z",
    "updated_at": "2026-09-04T20:33:32.000000Z"
  }
}
```

**Validation failure (HTTP 422):**

```json
{
  "message": "The name field is required. (and 1 more error)",
  "errors": {
    "name": ["The name field is required."],
    "mrn": ["The mrn field is required."]
  }
}
```

---

### PUT `/api/patients/{patient}` · PATCH `/api/patients/{patient}`

Update a patient. All fields optional (`sometimes`).

**Body:**

| Field | Type |
|---|---|
| `name` | string |
| `mrn` | string (unique, ignoring current record) |
| `medical_notes` | string \| null |

**Example success (HTTP 200):**

```json
{
  "data": {
    "id": 1,
    "name": "Kelton King",
    "mrn": "MRN-00001",
    "medical_notes": "Updated",
    "created_at": "2026-09-04T20:32:10.000000Z",
    "updated_at": "2026-09-04T20:33:33.000000Z"
  }
}
```

---

### DELETE `/api/patients/{patient}`

Hard-delete a patient (cascade-deletes their surgeries — the FK is `cascadeOnDelete`).

**Example success (HTTP 200):**

```json
{"message": "Patient deleted"}
```

---

### GET `/api/surgeries`

List all surgeries ordered by `scheduled_start` (asc), with `patient`, `surgeon`, `room`, `surgery_type` eager-loaded.

**Body:** no body.

**Example success (HTTP 200):** (one item shown — the full response is an array of all surgeries in the DB)

```json
{
  "data": [
    {
      "id": 1,
      "patient_id": 1,
      "surgeon_id": 4,
      "room_id": 1,
      "surgery_type_id": 1,
      "created_by": 2,
      "priority": "normal",
      "scheduled_start": "2026-09-04T14:00:00.000000Z",
      "estimated_duration_min": 240,
      "actual_start": null,
      "actual_end": null,
      "status": "scheduled",
      "patient": {"id": 1, "name": "Kelton King", "mrn": "MRN-00001", "medical_notes": null, "created_at": "2026-09-04T20:32:10.000000Z", "updated_at": "2026-09-04T20:32:10.000000Z"},
      "surgeon": {"id": 4, "name": "Dr. Ziemann", "email": "surgeon1@shifa.test", "role": "surgeon", "specialty": "Cardiology", "created_at": "2026-09-04T20:32:08.000000Z"},
      "room":    {"id": 1, "name": "OR-1", "status": "free", "supported_specialty": "Cardiology", "created_at": "2026-09-04T20:32:09.000000Z", "updated_at": "2026-09-04T20:32:09.000000Z"},
      "surgery_type": {"id": 1, "name": "Coronary Bypass", "average_duration_min": 240, "required_specialty": "Cardiology"}
    }
  ]
}
```

---

### GET `/api/surgeries/{surgery}`

Show a single surgery. Same shape as an item in the index, **plus** a `creator` (the coordinator who created it) — the show endpoint additionally eager-loads `creator`.

**Example success (HTTP 200):**

```json
{
  "data": {
    "id": 1,
    "patient_id": 1,
    "surgeon_id": 4,
    "room_id": 1,
    "surgery_type_id": 1,
    "created_by": 2,
    "priority": "normal",
    "scheduled_start": "2026-09-04T14:00:00.000000Z",
    "estimated_duration_min": 240,
    "actual_start": null,
    "actual_end": null,
    "status": "scheduled",
    "patient": {"id": 1, "name": "Kelton King", "mrn": "MRN-00001", "medical_notes": "Updated", "created_at": "2026-09-04T20:32:10.000000Z", "updated_at": "2026-09-04T20:33:33.000000Z"},
    "surgeon": {"id": 4, "name": "Dr. Ziemann", "email": "surgeon1@shifa.test", "role": "surgeon", "specialty": "Cardiology", "created_at": "2026-09-04T20:32:08.000000Z"},
    "room":    {"id": 1, "name": "OR-1", "status": "free", "supported_specialty": "Cardiology", "created_at": "2026-09-04T20:32:09.000000Z", "updated_at": "2026-09-04T20:32:09.000000Z"},
    "surgery_type": {"id": 1, "name": "Coronary Bypass", "average_duration_min": 240, "required_specialty": "Cardiology"},
    "creator": {"id": 2, "name": "Coordinator One Renamed", "email": "coord1@shifa.test", "role": "coordinator", "specialty": null, "created_at": "2026-09-04T20:32:07.000000Z"}
  }
}
```

---

### GET `/api/surgeries/calendar`

Return all surgeries between two dates, grouped by room, for the timeline view.

**Query parameters:**

| Param | Format | Default |
|---|---|---|
| `from` | `YYYY-MM-DD` | today (start of day) |
| `to`   | `YYYY-MM-DD` | today + 7 days (end of day) |

**Example success (HTTP 200):**

```json
{
  "from": "2026-09-01 00:00:00",
  "to": "2026-09-30 23:59:59",
  "rooms": [
    {
      "room_id": 4,
      "room_name": "OR-4",
      "surgeries": [
        { "id": 3, "patient_id": 3, "surgeon_id": 7, "room_id": 4, "surgery_type_id": 4, "created_by": 3, "priority": "emergency", "scheduled_start": "2026-09-03T10:00:00.000000Z", "estimated_duration_min": 60, "actual_start": "2026-09-03T10:00:00.000000Z", "actual_end": "2026-09-03T11:00:00.000000Z", "status": "completed", "patient": {"id": 3, "name": "Jeremy Maggio", "mrn": "MRN-00003", "medical_notes": null, "created_at": "2026-09-04T20:32:10.000000Z", "updated_at": "2026-09-04T20:32:10.000000Z"}, "surgeon": {"id": 7, "name": "Dr. Dach", "email": "surgeon4@shifa.test", "role": "surgeon", "specialty": "General", "created_at": "2026-09-04T20:32:09.000000Z"}, "room": {"id": 4, "name": "OR-4", "status": "free", "supported_specialty": "General", "created_at": "2026-09-04T20:32:09.000000Z", "updated_at": "2026-09-04T20:32:09.000000Z"}, "surgery_type": {"id": 4, "name": "Appendectomy", "average_duration_min": 60, "required_specialty": "General"} }
      ]
    }
  ]
}
```

(Only the first room+surgery shown for brevity — every room that has surgeries in the range is included, each with its full surgery list using the same surgery item shape as `/api/surgeries`.)

---

### POST `/api/surgeries`

Schedule a surgery.

**Body:**

| Field | Type | Required | Notes |
|---|---|---|---|
| `patient_id` | integer | yes | must exist in `patients` |
| `surgeon_id` | integer | yes | must exist in `users` |
| `room_id` | integer | yes | must exist in `operating_rooms` |
| `surgery_type_id` | integer | yes | must exist in `surgery_types` |
| `priority` | string | yes | `normal` or `emergency` |
| `scheduled_start` | datetime string | yes | any format Carbon accepts, e.g. `2026-09-10 10:00:00` |
| `estimated_duration_min` | integer | no | defaults to the surgery type's `average_duration_min` |

`created_by` is set automatically to the authenticated user. `status` is set to `scheduled`.

**Example success (HTTP 201):**

```json
{
  "data": {
    "id": 6,
    "patient_id": 6,
    "surgeon_id": 4,
    "room_id": 4,
    "surgery_type_id": 4,
    "created_by": 2,
    "priority": "normal",
    "scheduled_start": "2026-09-10T10:00:00.000000Z",
    "estimated_duration_min": 60,
    "actual_start": null,
    "actual_end": null,
    "status": "scheduled",
    "patient": {"id": 6, "name": "Ms. Mckayla Daniel", "mrn": "MRN-00006", "medical_notes": "Nihil voluptates pariatur illum quia consequatur architecto cum tenetur enim sed fugiat.", "created_at": "2026-09-04T20:32:10.000000Z", "updated_at": "2026-09-04T20:32:10.000000Z"},
    "surgeon": {"id": 4, "name": "Dr. Ziemann", "email": "surgeon1@shifa.test", "role": "surgeon", "specialty": "Cardiology", "created_at": "2026-09-04T20:32:08.000000Z"},
    "room":    {"id": 4, "name": "OR-4", "status": "free", "supported_specialty": "General", "created_at": "2026-09-04T20:32:09.000000Z", "updated_at": "2026-09-04T20:32:09.000000Z"},
    "surgery_type": {"id": 4, "name": "Appendectomy", "average_duration_min": 60, "required_specialty": "General"}
  }
}
```

---

### PUT `/api/surgeries/{surgery}` · PATCH `/api/surgeries/{surgery}`

Update a surgery. All fields optional (`sometimes`).

**Body:** same fields as create, plus `status ∈ {scheduled, in_progress, completed, cancelled, delayed}`.

**Example success (HTTP 200):**

```json
{
  "data": {
    "id": 1,
    "patient_id": 1,
    "surgeon_id": 4,
    "room_id": 1,
    "surgery_type_id": 1,
    "created_by": 2,
    "priority": "emergency",
    "scheduled_start": "2026-09-04T14:00:00.000000Z",
    "estimated_duration_min": 240,
    "actual_start": null,
    "actual_end": null,
    "status": "scheduled",
    "patient": {"id": 1, "name": "Kelton King", "mrn": "MRN-00001", "medical_notes": "Updated", "created_at": "2026-09-04T20:32:10.000000Z", "updated_at": "2026-09-04T20:33:33.000000Z"},
    "surgeon": {"id": 4, "name": "Dr. Ziemann", "email": "surgeon1@shifa.test", "role": "surgeon", "specialty": "Cardiology", "created_at": "2026-09-04T20:32:08.000000Z"},
    "room":    {"id": 1, "name": "OR-1", "status": "free", "supported_specialty": "Cardiology", "created_at": "2026-09-04T20:32:09.000000Z", "updated_at": "2026-09-04T20:32:09.000000Z"},
    "surgery_type": {"id": 1, "name": "Coronary Bypass", "average_duration_min": 240, "required_specialty": "Cardiology"}
  }
}
```

---

### DELETE `/api/surgeries/{surgery}`

**Does not hard-delete** — updates the surgery's status to `cancelled`.

**Example success (HTTP 200):**

```json
{"message": "Surgery cancelled"}
```

---

### POST `/api/surgeries/auto-schedule`

Ask the [SchedulingService](app/Services/SchedulingService.php) to build a proposed schedule from a batch of pending surgeries. **Nothing is persisted** — the coordinator reviews and then confirms by calling `POST /api/surgeries` per accepted proposal.

**Body:**

```json
{
  "pending": [
    {"patient_id": 7, "surgeon_id": 4, "surgery_type_id": 4, "priority": "emergency"},
    {"patient_id": 8, "surgeon_id": 6, "surgery_type_id": 2, "priority": "normal"}
  ]
}
```

Each item requires `patient_id`, `surgeon_id`, `surgery_type_id` (all must exist), and `priority ∈ {normal, emergency}`.

**Example success (HTTP 200):**

```json
{
  "proposals": [
    {
      "patient_id": 7,
      "surgeon_id": 4,
      "surgery_type_id": 4,
      "priority": "emergency",
      "room_id": 4,
      "scheduled_start": "2026-09-04 08:00:00",
      "estimated_duration_min": 60,
      "reason": "Room specialty 'General' matched."
    },
    {
      "patient_id": 8,
      "surgeon_id": 6,
      "surgery_type_id": 2,
      "priority": "normal",
      "room_id": 2,
      "scheduled_start": "2026-09-04 08:00:00",
      "estimated_duration_min": 120,
      "reason": "Room specialty 'Orthopedics' matched."
    }
  ]
}
```

**Validation failure (HTTP 422):**

```json
{
  "message": "The pending field is required.",
  "errors": {"pending": ["The pending field is required."]}
}
```

---

### GET `/api/schedule-suggestions`

List all `pending` schedule suggestions, most recent first, with `surgery` and `suggested_room` eager-loaded.

**Body:** no body.

**Example success (HTTP 200):**

```json
{
  "data": [
    {
      "id": 1,
      "surgery_id": 4,
      "suggested_room_id": 5,
      "suggested_start": "2026-09-05T20:32:13.000000Z",
      "reason": "Manual probe suggestion for API doc.",
      "status": "pending",
      "surgery": {"id": 4, "patient_id": 4, "surgeon_id": 6, "room_id": 3, "surgery_type_id": 3, "created_by": 3, "priority": "normal", "scheduled_start": "2026-09-05T09:00:00.000000Z", "estimated_duration_min": 300, "actual_start": null, "actual_end": null, "status": "scheduled"},
      "suggested_room": {"id": 5, "name": "OR-5", "status": "free", "supported_specialty": null, "created_at": "2026-09-04T20:32:09.000000Z", "updated_at": "2026-09-04T20:32:09.000000Z"},
      "created_at": "2026-09-04T20:32:13.000000Z"
    }
  ]
}
```

Returns `{"data":[]}` when there are no pending suggestions.

---

### POST `/api/schedule-suggestions/{suggestion}/accept`

Accept a pending suggestion. Applies the suggestion's `suggested_room_id` and `suggested_start` to the underlying surgery, marks the suggestion `accepted`, and rejects any sibling pending suggestions for the same surgery.

**Body:** no body.

**Example success (HTTP 200):**

```json
{
  "data": {
    "id": 1,
    "surgery_id": 4,
    "suggested_room_id": 5,
    "suggested_start": "2026-09-05T20:32:13.000000Z",
    "reason": "Manual probe suggestion for API doc.",
    "status": "accepted",
    "surgery": {"id": 4, "patient_id": 4, "surgeon_id": 6, "room_id": 5, "surgery_type_id": 3, "created_by": 3, "priority": "normal", "scheduled_start": "2026-09-05T20:32:13.000000Z", "estimated_duration_min": 300, "actual_start": null, "actual_end": null, "status": "scheduled"},
    "suggested_room": {"id": 5, "name": "OR-5", "status": "free", "supported_specialty": null, "created_at": "2026-09-04T20:32:09.000000Z", "updated_at": "2026-09-04T20:32:09.000000Z"},
    "created_at": "2026-09-04T20:32:13.000000Z"
  }
}
```

**Suggestion already accepted or rejected (HTTP 422):**

```json
{"message": "Suggestion is not pending."}
```

**Not found (HTTP 404):**

```json
{"message": "No query results for model [App\\Models\\ScheduleSuggestion] 9999"}
```

---

### POST `/api/schedule-suggestions/{suggestion}/reject`

Mark a pending suggestion `rejected`. Does not touch the underlying surgery.

**Body:** no body.

**Example success (HTTP 200):**

```json
{
  "data": {
    "id": 2,
    "surgery_id": 4,
    "suggested_room_id": 3,
    "suggested_start": "2026-09-06T20:32:13.000000Z",
    "reason": "Alternate probe suggestion.",
    "status": "rejected",
    "created_at": "2026-09-04T20:32:13.000000Z"
  }
}
```

**Already actioned (HTTP 422):**

```json
{"message": "Suggestion is not pending."}
```

(In the observed run this is the response for suggestion #2 after suggestion #1 was accepted — accepting one suggestion automatically rejects sibling pending suggestions for the same surgery, so a subsequent explicit reject on #2 returns "not pending".)

---

## Surgeon

All endpoints in this section require `role=surgeon`. Requests from other roles return `HTTP 403 {"message":"Forbidden. Requires role: surgeon"}`.

### GET `/api/my-surgeries`

List all surgeries where `surgeon_id = current user`, ordered by `scheduled_start`. Eager-loads `patient`, `room`, `surgery_type` (but **not** `surgeon`, since it's implicit).

**Body:** no body.

**Example success (HTTP 200):** (as surgeon1 / id=4)

```json
{
  "data": [
    {
      "id": 1,
      "patient_id": 1,
      "surgeon_id": 4,
      "room_id": 1,
      "surgery_type_id": 1,
      "created_by": 2,
      "priority": "emergency",
      "scheduled_start": "2026-09-04T14:00:00.000000Z",
      "estimated_duration_min": 240,
      "actual_start": null,
      "actual_end": null,
      "status": "cancelled",
      "patient": {"id": 1, "name": "Kelton King", "mrn": "MRN-00001", "medical_notes": "Updated", "created_at": "2026-09-04T20:32:10.000000Z", "updated_at": "2026-09-04T20:33:33.000000Z"},
      "room":    {"id": 1, "name": "OR-1", "status": "free", "supported_specialty": "Cardiology", "created_at": "2026-09-04T20:32:09.000000Z", "updated_at": "2026-09-04T20:32:09.000000Z"},
      "surgery_type": {"id": 1, "name": "Coronary Bypass", "average_duration_min": 240, "required_specialty": "Cardiology"}
    }
  ]
}
```

Returns `{"data":[]}` for a surgeon with no assigned surgeries.

---

### POST `/api/surgeries/{surgery}/start`

Mark a surgery as started. Sets `actual_start = now()`, `status = in_progress`, and sets the room's `status = in_use`.

**Body:** no body.

**Example success (HTTP 200):**

```json
{
  "data": {
    "id": 5,
    "patient_id": 5,
    "surgeon_id": 7,
    "room_id": 4,
    "surgery_type_id": 5,
    "created_by": 2,
    "priority": "normal",
    "scheduled_start": "2026-09-05T14:00:00.000000Z",
    "estimated_duration_min": 90,
    "actual_start": "2026-09-04T20:33:51.000000Z",
    "actual_end": null,
    "status": "in_progress",
    "patient": {"id": 5, "name": "Bryon Hauck", "mrn": "MRN-00005", "medical_notes": null, "created_at": "2026-09-04T20:32:10.000000Z", "updated_at": "2026-09-04T20:32:10.000000Z"},
    "surgeon": {"id": 7, "name": "Dr. Dach", "email": "surgeon4@shifa.test", "role": "surgeon", "specialty": "General", "created_at": "2026-09-04T20:32:09.000000Z"},
    "room":    {"id": 4, "name": "OR-4", "status": "in_use", "supported_specialty": "General", "created_at": "2026-09-04T20:32:09.000000Z", "updated_at": "2026-09-04T20:33:51.000000Z"},
    "surgery_type": {"id": 5, "name": "Hernia Repair", "average_duration_min": 90, "required_specialty": "General"}
  }
}
```

---

### POST `/api/surgeries/{surgery}/complete`

Mark a surgery as completed. Sets `actual_end = now()`, `status = completed`, and sets the room's `status = cleaning`.

**Body:** no body.

**Example success (HTTP 200):**

```json
{
  "data": {
    "id": 2,
    "patient_id": 2,
    "surgeon_id": 5,
    "room_id": 2,
    "surgery_type_id": 2,
    "created_by": 2,
    "priority": "normal",
    "scheduled_start": "2026-09-04T19:32:10.000000Z",
    "estimated_duration_min": 120,
    "actual_start": "2026-09-04T19:32:10.000000Z",
    "actual_end": "2026-09-04T20:33:54.000000Z",
    "status": "completed",
    "patient": {"id": 2, "name": "Cleve White", "mrn": "MRN-00002", "medical_notes": "Voluptatum consectetur ipsum doloremque a soluta provident blanditiis dicta.", "created_at": "2026-09-04T20:32:10.000000Z", "updated_at": "2026-09-04T20:32:10.000000Z"},
    "surgeon": {"id": 5, "name": "Dr. Prohaska", "email": "surgeon2@shifa.test", "role": "surgeon", "specialty": "Orthopedics", "created_at": "2026-09-04T20:32:08.000000Z"},
    "room":    {"id": 2, "name": "OR-2", "status": "cleaning", "supported_specialty": "Orthopedics", "created_at": "2026-09-04T20:32:09.000000Z", "updated_at": "2026-09-04T20:33:54.000000Z"},
    "surgery_type": {"id": 2, "name": "Knee Replacement", "average_duration_min": 120, "required_specialty": "Orthopedics"}
  }
}
```

---

### POST `/api/surgeries/{surgery}/delay`

Mark a surgery as `delayed` and invoke [`SchedulingService::handleDelay`](app/Services/SchedulingService.php). For every OTHER surgery scheduled in the SAME room LATER today, the service creates schedule suggestions and notifies all coordinators.

**Body:** no body.

**Example — no downstream surgeries in the same room (HTTP 200):**

```json
{
  "message": "Delay handled — 0 suggestion(s) generated.",
  "suggestions": []
}
```

**Example — one downstream surgery, two suggestions generated (HTTP 200):**

```json
{
  "message": "Delay handled — 2 suggestion(s) generated.",
  "suggestions": [
    {
      "id": 1,
      "surgery_id": 6,
      "suggested_room_id": 2,
      "suggested_start": "2026-09-04T23:50:18.000000Z",
      "reason": "Delayed by 15 min due to overrun of surgery #2 in the same room.",
      "status": "pending",
      "created_at": "2026-09-04T20:35:24.000000Z"
    },
    {
      "id": 2,
      "surgery_id": 6,
      "suggested_room_id": 5,
      "suggested_start": "2026-09-04T23:35:18.000000Z",
      "reason": "Move to room 'OR-5' to keep original start time despite overrun of surgery #2.",
      "status": "pending",
      "created_at": "2026-09-04T20:35:24.000000Z"
    }
  ]
}
```

For each affected surgery the service produces (a) a delayed-start suggestion in the same room, and (b) if any other free room supports the required specialty at the original start time, a room-move suggestion at the original time.

---

## Shared (any authenticated role)

### GET `/api/notifications`

List notifications for the current user, newest first.

**Body:** no body.

**Example success (HTTP 200):**

```json
{
  "data": [
    {
      "id": 1,
      "user_id": 2,
      "title": "Schedule adjustment suggested",
      "body": "Suggestion #1 for surgery #4: Manual probe suggestion for API doc.",
      "type": "schedule_suggestion",
      "read_at": null,
      "created_at": "2026-09-04T20:32:13.000000Z"
    }
  ]
}
```

Returns `{"data":[]}` for a user with no notifications.

---

### GET `/api/surgery-types`

List all surgery types ordered by name. Provided in the shared group because every role needs it to populate the surgery-type dropdown when scheduling.

**Body:** no body.

**Example success (HTTP 200):**

```json
{
  "data": [
    {"id": 4, "name": "Appendectomy", "average_duration_min": 60, "required_specialty": "General"},
    {"id": 3, "name": "Brain Tumor Resection", "average_duration_min": 300, "required_specialty": "Neurology"},
    {"id": 1, "name": "Coronary Bypass", "average_duration_min": 240, "required_specialty": "Cardiology"},
    {"id": 5, "name": "Hernia Repair", "average_duration_min": 90, "required_specialty": "General"},
    {"id": 2, "name": "Knee Replacement", "average_duration_min": 120, "required_specialty": "Orthopedics"}
  ]
}
```

**Unauthenticated (HTTP 401):**

```json
{"message": "Unauthenticated."}
```

---

### POST `/api/notifications/{notification}/read`

Mark one of the current user's notifications as read (sets `read_at = now()`).

**Body:** no body.

**Example success (HTTP 200):**

```json
{
  "data": {
    "id": 1,
    "user_id": 2,
    "title": "Schedule adjustment suggested",
    "body": "Suggestion #1 for surgery #4: Manual probe suggestion for API doc.",
    "type": "schedule_suggestion",
    "read_at": "2026-09-04T20:33:55.000000Z",
    "created_at": "2026-09-04T20:32:13.000000Z"
  }
}
```

**Trying to mark another user's notification (HTTP 403):**

```json
{"message": "Forbidden"}
```

**Not found (HTTP 404):**

```json
{"message": "No query results for model [App\\Models\\Notification] 9999"}
```

---

## Appendix: seeded IDs used above

Running `php artisan migrate:fresh --seed` produces this fixed layout (patient/surgeon names vary run-to-run since they come from Faker, but IDs and roles are stable):

**Users**
| id | email | role | specialty |
|---|---|---|---|
| 1 | admin@shifa.test | admin | — |
| 2 | coord1@shifa.test | coordinator | — |
| 3 | coord2@shifa.test | coordinator | — |
| 4 | surgeon1@shifa.test | surgeon | Cardiology |
| 5 | surgeon2@shifa.test | surgeon | Orthopedics |
| 6 | surgeon3@shifa.test | surgeon | Neurology |
| 7 | surgeon4@shifa.test | surgeon | General |

All accounts use password `password`.

**Operating rooms:** OR-1 Cardiology, OR-2 Orthopedics, OR-3 Neurology, OR-4 General, OR-5 (no specialty).

**Surgery types:** 1 Coronary Bypass (240 min / Cardiology), 2 Knee Replacement (120 min / Orthopedics), 3 Brain Tumor Resection (300 min / Neurology), 4 Appendectomy (60 min / General), 5 Hernia Repair (90 min / General).

**Patients:** IDs 1–10.

**Surgeries:** 5 pre-seeded (id 1 today scheduled, id 2 today in_progress, id 3 yesterday completed, id 4 tomorrow scheduled, id 5 tomorrow scheduled).
