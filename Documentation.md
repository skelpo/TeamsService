# Team Service Route Documentation

The Team Service handles the connection between a user and a team. It stores the teams a user is a member of and visa versa.

## Routes:

All routes require a JWT access token passed in with the `Authorization` header with the OAuth 2.0 format:

    Bearer {{token}}
   

### POST `/teams`

Creates a new team, with the user as a member with the admin status.

**Parameters:**

|  Name  |   Type   |               Description                 | Required |
|--------|----------|-------------------------------------------|----------|
| `name` | `string` | The name of the team that will be created |   True   |

**Response:**

	{
	    "team": {
	        "id": 28,
	        "name": "Some Team",
	        "members": [
	            {
	                "status": 0,
	                "status_name": "admin",
	                "user_id": 2,
	                "id": 29
	            }
	        ]
	    },
	    "message": "You should re-authenticate so you can access the team you just created"
	}

---

### GET `/teams`

Gets all the teams that the user is a member of.

**Parameters:** `N/A`

**Response:**

	[
	    {
	        "id": 28,
	        "name": "Some Team",
	        "members": [
	            {
	                "status": 0,
	                "status_name": "admin",
	                "user_id": 2,
	                "id": 29
	            }
	        ]
	    },
	    {
	        "id": 29,
	        "name": "Another Team",
	        "members": [
	            {
	                "status": 0,
	                "status_name": "admin",
	                "user_id": 2,
	                "id": 30
	            }
	        ]
	    },...
	]

---

### DELETE `/teams/:int`

Deletes a team and all its member connections with the users.

**Parameters:**

|   Name   | Type  |               Description                             | Required |
|----------|-------|-------------------------------------------------------|----------|
| `status` | `int` | The status of the user in the team they are deleteing |   True   |


**Route Parameters:**

| Position | Type  |          Description         |
|----------|-------|------------------------------|
|   `0`    | `int` | The ID of the team to delete |

**Response:**

	{
	    "status": 200,
	    "message": "Team 'Another Team' was deleted"
	}

---

### GET `/teams/:int`

Gets a team.

**Parameters:** `N/A`

**Route Parameters:**

| Position | Type  |          Description        |
|----------|-------|-----------------------------|
|   `0`    | `int` | The ID of the team to fetch |

**Response**

	{
	    "id": 30,
	    "name": "Some Team",
	    "members": [
	        {
	            "status": 0,
	            "status_name": "admin",
	            "user_id": 2,
	            "id": 31
	        }
	    ]
	}

---

### POST `/teams/:int/users`

Adds a user as a member to a team.

**Parameters:**

|     Name     | Type  |                    Description                       | Required |
|--------------|-------|------------------------------------------------------|----------|
| `status`     | `int` | The status of the member adding the user to the team |   True   |
| `new_status` | `int` | The status of the member being added to the team     |   True   |
| `user_id`    | `int` | The ID of the user that will be added to the team    |   True   |


**Route Parameters:**

| Position | Type  |              Description              |
|----------|-------|---------------------------------------|
|   `0`    | `int` | The ID of the team to add the user to |

**Response:**

	{
	    "status": 1,
	    "status_name": "standard",
	    "user_id": 28,
	    "id": 33
	}

---

### DELETE `/teams/:int/users/:int`

Removes a user from a team.

**Parameters:**

|     Name     | Type  |                      Description                         | Required |
|--------------|-------|----------------------------------------------------------|----------|
| `status`     | `int` | The status of the member removing the user from the team |   True   |


**Route Parameters:**

| Position | Type  |                   Description                  |
|----------|-------|------------------------------------------------|
|   `0`    | `int` | The ID of the team to remove the user from     |
|   `1`    | `int` | The ID of the user to remove the from the team |

**Response:**

	{
	    "status": 200,
	    "message": "Member with the ID '34' was removed from team"
	}

---

### GET `/teams/users/:int/teams`

Gets all the teams a user is a member of.

**Parameters:** `N/A`

**Route Parameters:**

| Position | Type  |                 Description                |
|----------|-------|--------------------------------------------|
|   `0`    | `int` | The ID of the user to get the teams for    |

**Response:**

	[
	    {
	        "id": 32,
	        "name": "Some Team",
	        "members": [
	            {
	                "status": 0,
	                "status_name": "admin",
	                "user_id": 2,
	                "id": 35
	            },
	            {
	                "status": 1,
	                "status_name": "standard",
	                "user_id": 34,
	                "id": 36
	            },
	            {
	                "status": 0,
	                "status_name": "admin",
	                "user_id": 34,
	                "id": 37
	            }
	        ]
	    },...
	]

---

### GET `/teams/health`

Used by AWS to check whether the E2C instance needs to be re-booted.

**Parameters:** `N/A`

**Response:**

    all good

