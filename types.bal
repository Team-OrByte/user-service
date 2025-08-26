type User record {
    string userId;
    string fullName;
    string email;
    string phoneNumber;
    string userAddress;
    string? profilePicture;
    string createdAt;
    string updatedAt;
    boolean? compatibility;
};

type UserInsert record {
    string fullName;
    string email;
    string phoneNumber;
    string userAddress;
    string? profilePicture;
};

type UserUpdate record {
    string? fullName;
    string? email;
    string? phoneNumber;
    string? userAddress;
    string? profilePicture;
};

type UserPreferences record {
    string userId;
    string preferredLanguage;
    boolean notificationsEnabled;
};

type Response record {
    string? message;
    anydata? data;
};

public type Claims record {|
    string? userId;
    string? email;
    string? role;
|};