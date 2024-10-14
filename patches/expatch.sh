#!/bin/bash

set +e  # Disable exit on error

source="$(readlink -f -- $1)"
trebledroid="$source/patches/TrebleDroid"
personal="$source/patches/personal"

# Function to apply patches
apply_patches() {
    patch_dir=$1
    patch_source=$2
    printf "\n### APPLYING PATCHES FROM: $patch_source ###\n";
    sleep 1.0;
    
    for path in $(cd $patch_dir; echo *); do
        tree="$(tr _ / <<<$path | sed -e 's;platform/;;g')"
        printf "\n| $path ###\n";
        [ "$tree" == build ] && tree=build/make
        [ "$tree" == vendor/hardware/overlay ] && tree=vendor/hardware_overlay
        [ "$tree" == treble/app ] && tree=treble_app
        
        pushd $tree > /dev/null

        for patch in $patch_dir/$path/*.patch; do
            # Check if patch is already applied
            if patch -f -p1 --dry-run -R < $patch > /dev/null; then
                printf "### ALREADY APPLIED: $patch \n";
                continue
            fi

            # Try to apply the patch
            if git apply --check $patch; then
                git am $patch
                printf "### PATCH APPLIED SUCCESSFULLY: $patch \n"
            elif patch -f -p1 --dry-run < $patch > /dev/null; then
                printf "### TRYING TO APPLY: $patch \n"
                git am $patch || true
                patch -f -p1 < $patch
                git add -u
                git am --continue
                printf "### PATCH APPLIED WITH MODIFICATIONS: $patch \n"
            else
                printf "### FAILED APPLYING: $patch \n"
            fi
        done

        popd > /dev/null
    done
}

# Apply TrebleDroid patches
apply_patches $trebledroid "TrebleDroid"

# Apply Personal patches
apply_patches $personal "Personal"

# End of script
printf "\n### PATCHING PROCESS COMPLETED ###\n"
