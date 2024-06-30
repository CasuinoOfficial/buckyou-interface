#[allow(unused_function, unused_field, unused_type_parameter)]
module buckyou_interface_v2::final {

    use sui::object::UID;
    use sui::tx_context::TxContext;
    use sui::coin::Coin;
    use sui::balance::Balance;
    use sui::clock::Clock;
    use typus_framework::big_vector::BigVector;
    use buckyou_interface_v2::listing::CoinTypeWhitelist;
    use buckyou_interface_v2::profile_manager::ProfileManager;
    use buckyou_interface_v2::game_status::GameStatus;

    //***********************
    //  Errors
    //***********************

    const EPoolAlreadySplitted: u64 = 0;
    fun err_pool_already_splitted() { abort EPoolAlreadySplitted }

    const EPoolTypeNotExists: u64 = 1;
    fun err_pool_type_not_exists() { abort EPoolTypeNotExists }

    //***********************
    //  Events
    //***********************

    struct Deposit<phantom T> has copy, drop {
        amount: u64,
    }

    //***********************
    //  Objects
    //***********************

    struct FinalPool has key {
        id: UID,
        dev: address,
        openers: BigVector<address>,
    }

    struct SinglePool<phantom T> has key, store {
        id: UID,
        is_splitted: bool,
        main_pool: Balance<T>,
    }

    struct LockedType<phantom T> has store, copy, drop {}

    struct LockedPool<phantom T> has key, store {
        id: UID,
        pool: Balance<T>,
    }

    //***********************
    //  Public Functions
    //***********************

    public fun deposit<T>(
        _whitelist: &CoinTypeWhitelist,
        _pool: &mut FinalPool,
        _game_status: &GameStatus,
        _clock: &Clock,
        _coin: Coin<T>,
        _ctx: &mut TxContext,
    ) {
        abort 0
    }

    public fun split_final_pool_after_game_ended<T>(
        _final_pool: &mut FinalPool,
        _game_status: &GameStatus,
        _clock: &Clock,
        _profile_manager: &ProfileManager,
        _ctx: &mut TxContext,
    ) {
        abort 0
    }
 
    public fun main_pool_balance<T>(_pool: &FinalPool): u64 {
        abort 0
    }
    
    public fun openers(pool: &FinalPool): &BigVector<address> {
        &pool.openers
    }
}
