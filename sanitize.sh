#!/usr/bin/env bash

## This will obviously not work in this form. It is usefull
## to keep for future regression tests though. sanitizier can
## also be replaced with VALGRID.


## These files also do not exist.
files=("brik_at_finn.png"
       "brik_pokemon_pikachu.png"
       "pinterest_at_finn.png"
       "pinterest_ctr_frog.png"
       "sma_toad_input.png"
       "smw2_yoshi_01_input.png"
       "smw_boo_input.png"
       "smw_bowser_input.png"
       "win31_386_input.png")


run_depixelize() {
    BIN="$(realpath src/depixelize-kopf2011/depixelize-kopf2011)"

    for f in "${files[@]}"; do

        filename="$(realpath ${2}/sample_inputs/${f})"
        
        echo "[${1}]" "${BIN}" "$filename" -o /dev/null -v
        "${BIN}" "$filename" -o /dev/null -v

        echo "[${1}]" "${BIN}" "$filename" -o /dev/null -g
        "${BIN}" "$filename" -o /dev/null -g

        echo "[${1}]" "${BIN}" "$filename" -o /dev/null -n
        "${BIN}" "$filename" -o /dev/null -n

        echo "[${1}]" "${BIN}" "$filename" -o /dev/null
        "${BIN}" "$filename" -o /dev/null
    done
}

addresssanitizer() {
    export ASAN_OPTIONS="detect_leaks=1"
    export LSAN_OPTIONS="suppressions=suppr.txt"

    mkdir -p address
    pushd address

    echo "leak:popt" > suppr.txt

    cmake -DCMAKE_CXX_COMPILER="clang++" -DCMAKE_BUILD_TYPE="Debug" -DCMAKE_CXX_FLAGS="-fsanitize=address -fno-omit-frame-pointer -O1 -fno-optimize-sibling-calls" ../..
    make

    run_depixelize "ADDRESS" "../.."

    popd
}

memorysanitizer() {
    mkdir -p memory
    pushd memory

    cmake -DCMAKE_CXX_COMPILER="clang++" -DCMAKE_BUILD_TYPE="Debug" -DCMAKE_CXX_FLAGS="-fsanitize=memory -fno-omit-frame-pointer -O1 -fno-optimize-sibling-calls" ../..
    make

    run_depixelize "MEMORY" "../.."

    popd
}

mkdir -p builds
pushd builds

addresssanitizer
#memorysanitizer

popd
rm -r builds
