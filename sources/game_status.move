#[allow(unused_function, unused_field, unused_type_parameter)]
module buckyou_interface_v2::game_status {

    use sui::clock::{Self, Clock};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::vec_set::{Self, VecSet};
    use buckyou_interface_v2::listing::ListingCap;
    use buckyou_interface_v2::math;
    use buckyou_interface_v2::config;

    //***********************
    //  Errors
    //***********************

    const EGameIsNotStarted: u64 = 0;
    fun err_game_is_not_started() { abort EGameIsNotStarted }

    const EGameIsNotEnded: u64 = 1;
    fun err_game_is_not_ended() { abort EGameIsNotEnded }

    const EGameIsEnded: u64 = 2;
    fun err_game_is_ended() { abort EGameIsEnded }

    const EInvalidPackageVersion: u64 = 3;
    fun err_invalid_package_version() { abort EInvalidPackageVersion }

    //***********************
    //  Events
    //***********************

    struct NewEndTime has copy, drop {
        ms: u64,
    }

    //***********************
    //  Objects
    //***********************

    struct GameStatus has key {
        id: UID,
        version_set: VecSet<u8>,
        start_time: u64,
        end_time: u64,
    }

    struct Starter has key {
        id: UID,
    }

    //***********************
    //  Constructor
    //***********************

    fun init(ctx: &mut TxContext) {
        let starter = Starter { id: object::new(ctx) };
        transfer::transfer(starter, tx_context::sender(ctx));
        let status = GameStatus {
            id: object::new(ctx),
            version_set: vec_set::singleton(package_version()),
            start_time: math::max_u64(),
            end_time: math::max_u64(),
        };
        transfer::share_object(status);
    }

    //***********************
    //  Public Functions
    //***********************   

    public fun start(
        status: &mut GameStatus,
        starter: Starter,
        start_time: u64,
    ) {
        let Starter { id } = starter;
        object::delete(id);

        status.start_time = start_time;
        status.end_time = start_time + config::initial_countdown();
    }

    public fun add_version(
        _: &ListingCap,
        status: &mut GameStatus,
        version: u8,
    ) {
        assert_valid_package_version(status);
        vec_set::insert(&mut status.version_set, version);
    }

    public fun remove_version(
        _: &ListingCap,
        status: &mut GameStatus,
        version: u8,
    ) {
        assert_valid_package_version(status);
        vec_set::remove(&mut status.version_set, &version);
    }

    //***********************
    //  Getter Functions
    //***********************

    public fun assert_game_is_started(
        status: &GameStatus,
        clock: &Clock,
    ) {
        let current_time = clock::timestamp_ms(clock);
        if (current_time < status.start_time) err_game_is_not_started();
    }

    public fun assert_game_is_ended(
        status: &GameStatus,
        clock: &Clock,
    ) {
        let current_time = clock::timestamp_ms(clock);
        if (current_time <= status.end_time) err_game_is_not_ended();
    }

    public fun assert_game_is_not_ended(
        status: &GameStatus,
        clock: &Clock,
    ) {
        let current_time = clock::timestamp_ms(clock);
        if (current_time > status.end_time) err_game_is_ended();
    }

    public fun assert_valid_package_version(
        status: &GameStatus,
    ) {
        if (!vec_set::contains(&status.version_set, &package_version()))
            err_invalid_package_version();
    }

    public fun package_version(): u8 { 1 }

    public fun start_time(status: &GameStatus): u64 {
        status.start_time
    }

    public fun cliff_time(status: &GameStatus): u64 {
        let start_time = status.start_time;
        let initial_countdown = config::initial_countdown();
        if (start_time <= math::max_u64() - initial_countdown) {
            start_time + initial_countdown
        } else {
            start_time
        }
    }

    public fun end_time(status: &GameStatus): u64 {
        status.end_time
    }

    public fun raffle_epoch(
        game_status: &GameStatus,
        clock: &Clock,
    ): u64 {
        let start_time = start_time(game_status);
        let current_time = clock::timestamp_ms(clock);
        if (current_time >= start_time) {
            (current_time - start_time) / config::raffle_period()
        } else {
            0
        }
    }
}
