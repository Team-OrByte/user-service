import ballerina/http;
import ballerina/log;
import ballerina/sql;
import ballerina/time;
import ballerina/uuid;
import ballerinax/postgresql;

configurable int db_port = ?;
configurable string db_host = ?;
configurable string db_pass = ?;
configurable string db_user = ?;
configurable string db_name = ?;

postgresql:Options postgresqlOptions = {
    connectTimeout: 10
};
postgresql:Client dbClient = check new (username = db_user, password = db_pass, database = db_name, host = db_host, port = db_port, options = postgresqlOptions);

service /user\-service on new http:Listener(5000) {

    resource function get users() returns Response {
        log:printInfo("Received request: GET /users");

        sql:ParameterizedQuery query = `SELECT * FROM users_profile`;
        stream<User, sql:Error?> result = dbClient->query(query, User);
        User[] users = [];

        error? e = result.forEach(function(User user) {
            users.push(user);
        });

        if e is error {
            log:printError("Error while processing users stream", err = e.toString());
            return {
                message: "Failed to get users",
                data: []
            };
        } else {
            log:printInfo("Successfully retrieved users: " + users.length().toString());
            return {
                message: "users list retrieved successfully",
                data: users
            };
        }
    }

    resource function post create\-user(@http:Payload UserInsert newUser) returns Response {
        string userId = uuid:createType1AsString();
        time:Utc currentTime = time:utcNow(); 

        sql:ParameterizedQuery insertQuery = `INSERT INTO users_profile (user_id, full_name, email, phone_number, user_address, profile_picture, created_at, updated_at)
        VALUES (${userId}, ${newUser.fullName}, ${newUser.email}, ${newUser.phoneNumber}, ${newUser.userAddress}, ${newUser.profilePicture}, ${currentTime}, ${currentTime})`;

        var result = dbClient->execute(insertQuery);

        if result is sql:Error {
            log:printError("Failed to insert user", err = result.toString());
            return {message: "Failed to create user", data: []};
        }

        log:printInfo("User created successfully with ID: " + userId);
        return {message: "User created successfully", data: {id: userId}};
    }

    resource function put update\-user/[string userId](@http:Payload UserUpdate userUpdate) returns Response {
        log:printInfo("Received request: PUT /update-user/" + userId);

        sql:ParameterizedQuery getQuery = `SELECT * FROM users_profile WHERE user_id = ${userId}`;
        stream<User, sql:Error?> result = dbClient->query(getQuery, User);
        User? currentUser = ();
        error? fetchError = result.forEach(function(User user) {
            currentUser = user;
        });

        if fetchError is error || currentUser is () {
            log:printError("User not found");
            return {message: "User not found", data: []};
        }

        User user = <User>currentUser;
        string currentTime = time:utcToString(time:utcNow());

        string finalName = userUpdate.fullName ?: user.fullName;
        string finalEmail = userUpdate.email ?: user.email;
        string finalPhone = userUpdate.phoneNumber ?: user.phoneNumber;
        string finalAddress = userUpdate.userAddress ?: user.userAddress;
        string? finalProfile = userUpdate.profilePicture ?: user.profilePicture;

        sql:ParameterizedQuery updateQuery = `UPDATE users_profile SET
        full_name = ${finalName},
        email = ${finalEmail},
        phone_number = ${finalPhone},
        user_address = ${finalAddress},
        profile_picture = ${finalProfile},
        updated_at = ${currentTime} WHERE user_id = ${userId}`;

        var res = dbClient->execute(updateQuery);

        if res is sql:Error {
            log:printError("Failed to update user", err = result.toString());
            return {message: "Failed to update user", data: []};
        }

        log:printInfo("User updated successfully with ID: " + userId);
        return {message: "User updated successfully", data: {id: userId}};
    }

    resource function delete delete\-user/[string userId]() returns Response {
        log:printInfo("Received request: DELETE /delete-user/" + userId);

        sql:ParameterizedQuery deleteQuery = `DELETE FROM users_profile WHERE user_id = ${userId}`;
        var result = dbClient->execute(deleteQuery);

        if result is sql:Error {
            log:printError("Failed to delete user", err = result.toString());
            return {message: "Failed to delete user", data: []};
        }

        log:printInfo("User deleted successfully with ID: " + userId);
        return {message: "User deleted successfully", data: {id: userId}};
    }
}
