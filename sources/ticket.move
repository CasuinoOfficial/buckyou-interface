#[allow(unused_function, unused_field, unused_type_parameter)]
module buckyou_interface_v2::ticket {
    
    use std::ascii::String;
    use std::option::Option;
    use sui::object::{UID, ID};
    use sui::tx_context::TxContext;
    use sui::coin::Coin;
    use sui::clock::Clock;
    use buckyou_interface_v2::oracle::Oracle;
    use buckyou_interface_v2::final::FinalPool;
    use buckyou_interface_v2::lootbox::LootboxPool;
    use buckyou_interface_v2::game_status::GameStatus;
    use buckyou_interface_v2::profile_manager::ProfileManager;
    use buckyou_interface_v2::trove_manager::TroveManager;
    use buckyou_interface_v2::listing::{CoinTypeWhitelist, ObjectTypeWhitelist};

    //***********************
    //  Errors
    //***********************

    const EPaymentNotEnough: u64 = 0;
    fun err_payment_not_enough() { abort EPaymentNotEnough }

    //***********************
    //  Events
    //***********************

    struct Mint<phantom T> has copy, drop {
        id: ID,
        buyer: address,
        sender: address,
        referrer: Option<address>,
        cost: u64,
    }

    struct Buy has copy, drop {
        coin_type: String,
        buyer: address,
        sender: address,
        referrer: Option<address>,
        count: u64,
        payment: u64,
    }

    struct Open<phantom T> has copy, drop {
        opener: address,
        sender: address,
    }

    //***********************
    //  Objects
    //***********************

    // OTW
    struct TICKET has drop {}

    struct Ticket<phantom T> has key, store {
        id: UID,
        sender: address,
    }

    //***********************
    //  Public Functions
    //***********************

    public fun buy<T>(
        _clock: &Clock,
        _whitelist: &CoinTypeWhitelist,
        _oracle: &Oracle,
        _game_status: &mut GameStatus,
        _profile_manager: &mut ProfileManager,
        _trove_manager: &mut TroveManager,
        _final_pool: &mut FinalPool,
        _lootbox_pool: &mut LootboxPool,
        _coin: &mut Coin<T>, // if use zero coin then claim from trove and buy
        _count: u64,
        _referrer_opt: Option<address>,
        _on_behalf_of: address,
        _ctx: &mut TxContext,
    ): vector<Ticket<T>> {
        abort 0
    }

    public fun redeem<N: key + store>(
        _clock: &Clock,
        _whitelist: &ObjectTypeWhitelist,
        _game_status: &mut GameStatus,
        _profile_manager: &mut ProfileManager,
        _final_pool: &FinalPool,
        _object: N,
        _referrer_opt: Option<address>,
        _on_behalf_of: address,
        _ctx: &mut TxContext,
    ): Ticket<N> {
        abort 0
    }

    public fun open<T>(
        _clock: &Clock,
        _game_status: &mut GameStatus,
        _profile_manager: &mut ProfileManager,
        _final_pool: &mut FinalPool,
        _ticket: Ticket<T>,
        _ctx: &mut TxContext,
    ) {
        abort 0
    }

    //***********************
    //  Getter Functions
    //***********************

    public fun sender<T>(ticket: &Ticket<T>): address {
        ticket.sender
    }
}