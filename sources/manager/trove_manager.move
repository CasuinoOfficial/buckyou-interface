#[allow(unused_function, unused_field, unused_type_parameter)]
module buckyou_interface_v2::trove_manager {

    use std::option::Option;
    use std::string::String;
    use sui::object::UID;
    use sui::table::Table;
    use sui::coin::Coin;
    use sui::bag::Bag as Trove;
    use sui::tx_context::TxContext;
    
    const ENotEnoughtInTrove: u64 = 0;
    fun err_not_enough_in_trove() { abort ENotEnoughtInTrove }

    const EUserTroveNotFound: u64 = 1;
    fun err_user_trove_not_found() { abort EUserTroveNotFound }

    const EAssetNotFoundInTrove: u64 = 2;
    fun err_asset_not_found_in_trove() { abort EAssetNotFoundInTrove }

    //***********************
    //  Events
    //***********************

    struct Deposit<phantom T> has copy, drop {
        user: address,
        amount: u64,
        source: String,
        from: Option<address>,
    }

    struct Withdraw<phantom T> has copy, drop {
        user: address,
        amount: u64,
    }

    //***********************
    //  Objects
    //***********************

    struct TroveManager has key {
        id: UID,
        trove_map: Table<address, Trove>,
    }

    //***********************
    //  Public Functions
    //***********************

    public fun take_coin_from_trove<T>(
        _manager: &mut TroveManager,
        _amount: u64,
        _ctx: &mut TxContext,
    ): Coin<T> {
        abort 0
    }

    public fun take_all_from_trove<T>(
        _manager: &mut TroveManager,
        _ctx: &mut TxContext,
    ): Coin<T> {
        abort 0
    }

    //***********************
    //  Getter Functions
    //***********************

    public fun get_trove_value<T>(
        _manager: &TroveManager,
        _user: address,
    ): u64 {
        abort 0
    }
}
