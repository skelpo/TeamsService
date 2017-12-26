# Team Service Route Documentation

The Team Service handles the connection between a user and a team. It stores the teams a user is a member of and visa versa.

## Routes:

All routes require a JWT access token passed in with the `Authorization` header with the following format:

    Bearer {{token}}
   

### POST `/teams`

Creates a new team, with the user as a member with the admin status.

**Request Body Values:**

|     |     |
| --- | --- |
| **name** | The name for the team |

---

### GET `/teams`

Gets all the teams that the user is a member of.

---

### DELETE `/teams/:int`

Removes a user from a team.

**Request Body Values:**

|     |     |
| --- | --- |
| **status** | The status of the user trying to delete the team |

**Route Parameters:**

|     |     |
| --- | --- |
| **0** | The ID of the user to remove |

---

### GET `/teams/:int`

Gets a team.

**Route Parameters:**

|     |     |
| --- | --- |
| **0** | The ID of the team to get |

---

### POST `/teams/:int/users`

Adds a user as a member to a team.

**Request Body Values:**

|     |     |
| --- | --- |
| **status** | The status of the member adding the user to the team |
| **new_status** | The status of the member to add the team |
| **user_id** | The ID of the user that will be added to the team |

**Route Parameters:**

|     |     |
| --- | --- |
| **0** | The ID of the team to add the user to |

---

### DELETE `/teams/:int/users/:int`

Removes a user from a team.

**Request Body Values:**

|     |     |
| --- | --- |
| **status** | The status of the member removing the user from the team |

**Route Parameters:**

|     |     |
| --- | --- |
| **0** | The ID of the team to remove the user from |
| **1** | The ID of the user to remove the from the team |

---

### GET `/teams/users/:int/teams`

Gets all the teams a user is a member of.

**Route Parameters:**

|     |     |
| --- | --- |
| **0** | The ID of the user to get the teams for |

---

### GET `/teams/health`
