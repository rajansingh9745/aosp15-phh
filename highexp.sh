#!/bin/bash

set +e  # Disable exit on error

source="$(readlink -f -- $1)"
trebledroid="$source/patches/TrebleDroid"
personal="$source/patches/personal"

# Function to apply patches
apply_patches() {
    patch_dir=$1
    patch_source=$2
    printf "\n### APPLYING PATCHES FROM: $patch_source ###\n"
    sleep 1.0

    for path in $(cd $patch_dir; echo *); do
        tree="$(tr _ / <<<$path | sed -e 's;platform/;;g')"
        printf "\n| $path ###\n"
        [ "$tree" == build ] && tree=build/make
        [ "$tree" == vendor/hardware/overlay ] && tree=vendor/hardware_overlay
        [ "$tree" == treble/app ] && tree=treble_app

        pushd $tree > /dev/null

        for patch in $patch_dir/$path/*.patch; do
            # Extract the file(s) being patched
            files_changed=$(grep '^diff --git' $patch | awk '{print $3}' | sed 's/a\///')

            # Check if patch is already applied by verifying the content changes
            already_applied=true
            for file in $files_changed; do
                if ! patch -p1 --dry-run -R < $patch > /dev/null 2>&1; then
                    already_applied=false
                    break
                fi
            done

            if [ "$already_applied" = true ]; then
                printf "### PATCH ALREADY APPLIED: $patch \n"
                continue
            fi

            # Try to apply the patch
            if git apply --check $patch; then
                git am $patch
                printf "### PATCH APPLIED SUCCESSFULLY: $patch \n"
            elif patch -f -p1 --dry-run < $patch > /dev/null; then
                printf "### TRYING TO APPLY: $patch \n"
                git am $patch || true

                # Apply patch to the file directly if it failed
                for file in $files_changed; do
                    while read -r line; do
                        # Extract the line from the patch that should be applied
                        if [[ $line =~ ^\+ ]]; then
                            new_line="${line:1}"  # Remove the '+' sign
                            # Search for the existing line in the file
                            existing_line=$(grep -n "${new_line}" "$file" | cut -d: -f1)

                            # If found, replace the line in the file
                            if [ -n "$existing_line" ]; then
                                sed -i "${existing_line}s/.*/${new_line}/" "$file"
                                printf "### REPLACED LINE IN $file: $existing_line\n"
                            else
                                printf "### LINE TO REPLACE NOT FOUND IN $file\n"
                            fi
                        fi
                    done < "$patch"
                done

                # Finalize the changes
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
