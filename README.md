# KeyValueStorage
TW KeyValueStorage Test

Transactional Key Value Store

The assignment is to build an interactive command line interface to a transactional key value store.

A user should be able to compile and run this program and get an interactive shell with a prompt where they can type commands.

The user can enter commands to set/get/delete key/value pairs and count values.

All values can be treated as strings, no need to differentiate by type.

The key/value data only needs to exist in memory for the session, it does not need to be written to disk.

The interface should also allow the user to perform operations in transactions, which allows the user to commit or roll back their changes to the key value store.

That includes the ability to nest transactions and roll back and commit within nested transactions.

The solution shouldn't depend on any third party libraries.
