#[allow(unused_function)]
module buckyou_interface_v2::listing {

    use std::type_name::{Self, TypeName};
    use sui::object::UID;
    use sui::vec_set::{Self, VecSet};

    //***********************
    //  Errors
    //***********************

    const ECoinTypeAlreadyListed: u64 = 0;
    fun err_coin_type_already_listed() { abort ECoinTypeAlreadyListed }

    const ECoinTypeNotExists: u64 = 1;
    fun err_coin_type_not_exists() { abort ECoinTypeNotExists }

    const ECoinTypeNotListed: u64 = 2;
    fun err_coin_type_not_listed() { abort ECoinTypeNotListed }

    const EObjectTypeNotExists: u64 = 3;
    fun err_object_type_not_exists() { abort EObjectTypeNotExists }

    const EObjectTypeNotListed: u64 = 4;
    fun err_object_type_not_listed() { abort EObjectTypeNotListed }

    //***********************
    //  Events
    //***********************

    struct CoinTypeListed<phantom T> has copy, drop {}

    struct CoinTypeDelisted<phantom T> has copy, drop {}

    struct ObjectTypeListed<phantom T> has copy, drop {}

    struct ObjectTypeDelisted<phantom T> has copy, drop {}

    //***********************
    //  Objects
    //***********************

    struct ListingCap has key, store {
        id: UID,
    }

    struct CoinTypeWhitelist has key {
        id: UID,
        types: VecSet<TypeName>,
    }

    struct ObjectTypeWhitelist has key {
        id: UID,
        types: VecSet<TypeName>,
    }

    //***********************
    //  Getter Functions
    //***********************

    public fun coin_type_is_listed<T>(
        whitelist: &CoinTypeWhitelist,
    ): bool {
        vec_set::contains(
            &whitelist.types,
            &type_name::get<T>(),
        )
    }

    public fun object_type_is_listed<T>(
        whitelist: &ObjectTypeWhitelist,
    ): bool {
        vec_set::contains(
            &whitelist.types,
            &type_name::get<T>(),
        )
    }
}
