#[allow(unused_function, unused_field, unused_type_parameter)]
module buckyou_interface_v2::lootbox {

    use std::ascii::String;
    use std::type_name::{Self, TypeName};
    use sui::object::UID;
    use sui::tx_context::TxContext;
    use sui::coin::Coin;
    use sui::balance::{Self, Balance};
    use sui::object_table::{Self as table, ObjectTable as Table};
    use sui::clock::Clock;
    use sui::bag::{Self, Bag};
    use typus_framework::big_vector::BigVector;
    use buckyou_interface_v2::listing::CoinTypeWhitelist;
    use buckyou_interface_v2::trove_manager::TroveManager;
    use buckyou_interface_v2::game_status::GameStatus;

    //***********************
    //  Errors
    //***********************


    const EEpochNotExists: u64 = 0;
    fun err_epoch_not_exists() { abort EEpochNotExists }

    const EEpochNotEnded: u64 = 1;
    fun err_epoch_not_ended() { abort EEpochNotEnded }

    const EEpochAlreadyRaffled: u64 = 2;
    fun err_epoch_already_raffled() { abort EEpochAlreadyRaffled }

    const EEpochNotRaffled: u64 = 3;
    fun err_epoch_not_raffled() { abort EEpochNotRaffled }

    const EPoolsNotEmpty: u64 = 4;
    fun err_pools_not_empty() { abort EPoolsNotEmpty }

    //***********************
    //  Events
    //***********************

    struct Deposit<phantom T> has copy, drop {
        amount: u64,
        pool_size: u64,
    }

    struct RaffleResult has copy, drop {
        epoch: u64,
        winners: vector<address>,
    }

    struct RafflePrize has copy, drop {
        coin_type: String,
        epoch: u64,
        total_prize: u64,
    }

    //***********************
    //  Objects
    //***********************

    struct LootboxPool has key {
        id: UID,
        verifier_pub_key: vector<u8>,
        periods: Table<u64, RafflePeriod>,
        dev: address,
    }

    struct RafflePeriod has key, store {
        id: UID,
        pools: Bag,
        is_raffled: bool,
        buyers: BigVector<address>,
        winners: vector<address>,
    }

    //***********************
    //  Public Functions
    //***********************

    public fun deposit<T>(
        _whitelist: &CoinTypeWhitelist,
        _pool: &mut LootboxPool,
        _game_status: &GameStatus,
        _clock: &Clock,
        _coin: Coin<T>,
        _ctx: &mut TxContext,
    ) {
        abort 0
    }

    public fun raffle(
        _pool: &mut LootboxPool,
        _game_status: &GameStatus,
        _clock: &Clock,
        _epoch: u64,
        _blg_sig: vector<u8>,        
    ) {
        abort 0
    }

    public fun settle<T>(
        _pool: &mut LootboxPool,
        _trove_manager: &mut TroveManager,
        _epoch: u64,
        _ctx: &mut TxContext,
    ) {
        abort 0
    }

    public fun destroy(
        _pool: &mut LootboxPool,
        _epoch: u64,
    ) {
        abort 0
    }

    //***********************
    //  Getter Functions
    //***********************

    public fun pool_size<T>(
        pool: &LootboxPool,
        epoch: u64,
    ): u64 {
        let coin_type = type_name::get<T>();
        if (!table::contains(&pool.periods, epoch)) return 0;
        let period = table::borrow(&pool.periods, epoch);
        if (bag::contains(&period.pools, coin_type)) {
            balance::value(bag::borrow<TypeName, Balance<T>>(&period.pools, coin_type))
        } else {
            0
        }
    }

    public fun buyers(
        pool: &LootboxPool,
        epoch: u64
    ): &BigVector<address> {
        let period = table::borrow(&pool.periods, epoch);
        &period.buyers
    }
}
