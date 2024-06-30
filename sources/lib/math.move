module buckyou_interface_v2::math {

    use std::vector as vec;
    use sui::bls12381::bls12381_min_pk_verify;
    use sui::hash::blake2b256;
    use sui::vec_set;

    //***********************
    //  Errors
    //***********************

    const EInvalidBlsSignature: u64 = 0;
    fun err_invalid_bls_signature() { abort EInvalidBlsSignature }

    //***********************
    //  Public Functions
    //***********************

    public fun max_u64(): u64 { 0xffffffffffffffff }

    public fun mul_and_div(x: u64, n: u64, m: u64): u64 {
        ((((x as u128) * (n as u128)) / (m as u128)) as u64)
    }

    public fun mul_and_div_u128(x: u64, n: u128, m: u128): u64 {
        (((x as u128) * n / m) as u64)
    }

    public fun bytes_to_u256(bytes: &vector<u8>): u256 {
        let output: u256 = 0;
        let bytes_length: u64 = 32;
        let idx: u64 = 0;
        while (idx < bytes_length) {
            let current_byte = *std::vector::borrow(bytes, idx);
            output = (output << 8) | (current_byte as u256) ;
            idx = idx + 1;
        };
        output
    }

    public fun verify_bls_sig_and_give_results(
        bls_sig: &mut vector<u8>,
        pub_key: &vector<u8>,
        msg: &vector<u8>,
        range: u64,
        result_count: u64,
    ): vector<u64> {
        if (!bls12381_min_pk_verify(bls_sig, pub_key, msg))
            err_invalid_bls_signature();
        get_result(bls_sig, range, result_count)
    }

    fun get_result(
        bls_sig: &mut vector<u8>,
        range: u64,
        result_count: u64,
    ): vector<u64> {
        let results = vec_set::empty<u64>();
        let range_u256 = (range as u256);
        let idx: u8 = 0;
        while (vec_set::size(&results) < result_count) {
            vec::push_back(bls_sig, idx);
            let hashed = blake2b256(bls_sig);
            let big_num = bytes_to_u256(&hashed);
            let result = ((big_num % range_u256) as u64);
            if (!vec_set::contains(&results, &result)) {
                vec_set::insert(&mut results, result);
            };
            vec::pop_back(bls_sig);
            if (idx == 0xff) break;
            idx = idx + 1;
        };
        vec_set::into_keys(results)
    }

    #[test]
    fun test_blake2b256(): u64 {
        let msg = vector[1,2,3];
        let hashed = blake2b256(&msg);
        // std::debug::print(&hashed);
        let num_u256 = bytes_to_u256(&hashed);
        // std::debug::print(&num_u256);
        let result = ((num_u256 % 1000u256) as u64);
        // std::debug::print(&result);
        result
    }

    #[test]
    fun test_get_results() {
        let bls_sig = vector[146,54,98,129,22,244,152,106,63,108,175,103,111,38,225,96,159,54,227,26,139,3,3,4,46,93,140,42,2,212,2,12,69,104,142,167,187,132,87,200,17,163,60,6,124,24,248,54,22,116,139,113,26,8,83,152,89,224,51,225,176,252,59,34,96,249,153,246,11,43,86,180,153,173,0,43,14,132,90,116,137,241,127,245,145,128,179,60,44,70,20,31,66,83,88,97];
        let bls_sig_copy = bls_sig;
        let results = get_result(&mut bls_sig, 100, 200);
        // std::debug::print(&results);
        // std::debug::print(&std::vector::length(&results));
        assert!(std::vector::length(&results) <= 200, 0);
        assert!(bls_sig == bls_sig_copy, 0);
        let results = get_result(&mut bls_sig, 1000, 200);
        // std::debug::print(&results);
        // std::debug::print(&std::vector::length(&results));
        assert!(std::vector::length(&results) <= 200, 0);
        assert!(bls_sig == bls_sig_copy, 0);
    }
}
