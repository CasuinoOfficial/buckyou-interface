#[allow(unused_function, unused_field, unused_type_parameter)]
module buckyou_interface_v2::oracle {

    use std::type_name::TypeName;
    use sui::object::UID;
    use sui::clock::Clock;

    //***********************
    //  Errors
    //***********************

    const EPriceFeedIsOutdated: u64 = 0;
    fun err_price_feed_is_outdated() { abort EPriceFeedIsOutdated }

    const EPriceFeedNotExists: u64 = 1;
    fun err_price_feed_not_exist() { abort EPriceFeedNotExists }

    const EPriceFeedAlreadyExists: u64 = 2;
    fun err_price_feed_already_exists() { abort EPriceFeedAlreadyExists }

    const EInvalidPriceRule: u64 = 3;
    fun err_invalid_price_rule() { abort EInvalidPriceRule }

    //***********************
    //  Objects
    //***********************

    struct Oracle has key {
        id: UID,
    }

    struct PriceFeed<phantom T> has store {
        price_against_sui: u128,
        latest_update_time: u64,
        decimals: u8,
        tolerance_ms: u64,
        rule: TypeName,
    }

    //***********************
    //  Public Functions
    //***********************

    public fun update_price<T, Rule: drop>(
        _: Rule,
        _oracle: &mut Oracle,
        _clock: &Clock,
        _price_against_sui: u128,
    ) {
        abort 0
    }

    //***********************
    //  Getter Functions
    //***********************

    public fun price_feed_exists<T>(_oracle: &Oracle): bool { abort 0 }

    public fun ticket_price<T>(
        _oracle: &Oracle,
        _clock: &Clock,
        _start_time: u64,
    ): u64 {
        abort 0
    }
}
