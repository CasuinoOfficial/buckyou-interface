#[allow(unused_function, unused_field, unused_type_parameter)]
module buckyou_interface_v2::profile_manager {

    use std::option::Option;
    use sui::object::UID;
    use sui::table::Table;
    use sui::tx_context::TxContext;
    use typus_framework::big_vector::BigVector;

    //***********************
    //  Errors
    //***********************

    const ESelfRecruited: u64 = 0;
    fun err_self_recruited() { abort ESelfRecruited }

    const EExceedTeamSize: u64 = 1;
    fun err_exceed_team_size() { abort EExceedTeamSize }

    //***********************
    //  Events
    //***********************

    struct NewProfile<phantom T> has copy, drop {
        player: address,
        senior: Option<address>,
        rank: u64,
        is_from_open: bool,
    }

    //***********************
    //  Objects
    //***********************

    struct ProfileManager has key {
        id: UID,
        map: Table<address, Profile>,
    }

    struct Profile has store {
        senior: Option<address>,
        juniors: BigVector<address>,
        team_size: u64,
        rank: u64,
        score: u64,
    }

    struct SELF has drop {}

    //***********************
    //  Public Funtions
    //***********************

    public fun set_referrer(
        _manager: &mut ProfileManager,
        _senior: address,
        _ctx: &mut TxContext,
    ) {
        abort 0
    }

    //***********************
    //  Getter Funtions
    //***********************

    public fun get_seniors(
        _manager: &ProfileManager,
        _player: address,
    ): (Option<address>, vector<address>) {
        abort 0
    }

    public fun get_score(
        _manager: &ProfileManager,
        _player: address,
    ): u64 {
        abort 0
    }
}
