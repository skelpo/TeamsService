# Skelpo Team Service

The Skelpo Team Service is an application micro-service writen with Swift and Vapor, a server-side Swift framework. This micro-service can be integrated into applications for grouping user's togeather; wheather that is in an actual team, an organization, or anything else. It is designed to be easily extenable, but useful and fully functional out-of-box.

## Getting Started

After we clone down the repo, we will setup the configuration file that are not tracked by git. Create a `secrets` directory in your apps `Config` directory. Then in your `secrets`, create a `mysql.json` file. The contents will look something like this:

    {
      "hostname": "127.0.0.1",
      "user": "<DATABASE_USER>",
      "password": "",
      "database": "<DATABASE_NAME>"
    }

This is the information used to connect the app to a MySQL database.

**Note:** Depending how the database is setup, you may or may not need a password. Additional information on setting up MySQL can be found on the [Vapor docs](https://docs.vapor.codes/2.0/mysql/package/).

Becuase the team service uses JWTs for authentication, we also need a `jwt.json` file in our `Config/secrets` directory. If you already have a service that uses JWT, then you can just copy over the contents from the `jwt.json` file that you used in that service. If you don't already have the JWT configuration, we will need to create it.

**TODO: Cover how to setup JWT. I'm confused about how to write it.**

Your service is now ready to run!

## Routes

If you want to add more routes to your service, you can create another controller in the `Sources/App/Controllers` directory or simply add the routes to one of the existing controllers. If you do create you own controller, you can either conform to `RouteCollection` to register the routes, or setup your own method of doing it. After you have created all your routes, it is time to register them with a `RouteBuilder` instance. If the routes are protected, then you will want to register your controller with the `api` route builder; however, if your routes are public, then you can register them directly with the droplet or create a different route builder so you can leverage middleware with your routes.

The routes for the service all start with a wildcard path element. This allows you to run multiple different versions of your API (with paths `/v1/...`, `/v2/...`, etc.) on AWS using the load balancer to figure out where to send the request to so we get the proper API version, while at the same time letting us ignore the version number (we don't need to know if it is correct or not because AWS takes care of that.)

## Teams

The `Team` model is nothing more then a name and ID, which a member connects to.

#### Adding Properties

You can add additional properties to the `Team` model if you want, though if the service is already running, they will have to be optional.

Start by adding the property to the model, and to the Row and JSON methods for serialization. Then we need to prepare the database table, so it has the new columns. If you can wipe the database, or haven't created one yet, you can add the preparation directly to the User.prepare method. However, if you already have the service up and running, you will need to modify the current table. This can be done by creating a struct that conforms to `Preparation` and adding it to your config's preparations. It will look something like this:

```swift
struct TeamModifier: Preparation {
    static func prepare(_ database: Database) throws {
        try database.modify(Team.self) { team in
            team.<type>("<COLUMN_NAME>", optional: nil, default: nil)
        }
    }

    static func revert(_ database: Database) throws {}
}
```

And this:

```
private func setupPreparations() throws {
    // Other preparations...
    // Add preparation in `Config.setupPreparations`.
    preparations.append(TeamModifier.self)
}
```

#### Routes

All of the routes for the `Team` model are protected by authentication. The payload in the access token must contain an array called `team_ids`, which contains the IDs of the Teams the user is a member of.

The routes for the `Team` model support all CRD operations (no, you can't update, but there isn't really anything _to_ update).

- `POST /teams`: Creates a new team with a given name and the user that created it as a member with the Admin status.
  
  This route requires a `name` parameter in the request body, used as the `name` property of the `Team`.
  
- `GET /teams`: Gets all the teams that the currently authenticated user is a member of.
  
- `GET /teams/:int`: Gets the team with the ID route parameter that the user is a nenber of. If the team exists, but the user is not a member, the route will return a 404.


- `DELETE /teams/:int`: Deletes the team with the given ID route parameter, along with all related member pivot connections.

  This route requires `status` parameter in the request body, which will be an `Int`. This parameter is used to make sure an Admin member is deleting the team.
