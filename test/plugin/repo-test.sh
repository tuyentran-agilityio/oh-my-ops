proj_dir=$(_do_proj_default_get_dir)
name="do-test-gen"

function test_do_repo_gen() {
    # Go to devops directory
    cd $proj_dir

    # Generates 
    rm -rfd $name

    _do_repo_gen $name

    local repo_dir="${proj_dir}/${name}"
    _do_dir_assert ${repo_dir}

    # .do.sh file should be there
    _do_file_assert ${repo_dir}/README.md
    _do_file_assert ${repo_dir}/.do.sh
    _do_file_assert ${repo_dir}/.editorconfig
    _do_file_assert ${repo_dir}/.gitignore
    _do_file_assert ${repo_dir}/.gitattributes

    # Git should be enabled for this repository
    _do_dir_assert $proj_dir/$name/.git

    rm -rfd $name
}

function test_do_repo_clone() {
    cd $proj_dir

    rm -rfd $name

    _do_repo_clone $name

    _do_dir_assert $proj_dir/$name

    rm -rfd $name
}

function test_do_list_repo() {
    # generates a new repository
    test_do_repo_gen

    for repo in $(_do_list_repo); do 
        # Try to find it.
        if [ "${repo}" = "do-test-gen" ]; then 
            return 0
        fi 
    done 

    _do_assert_fail
}

function test_repo_dir_array() {
    test_do_repo_gen

    local dir="${proj_dir}/do-test-gen/src"
    mkdir -p "${dir}/p1"
    touch "${dir}/p1/do1.txt"

    mkdir -p "${dir}/p2"
    touch "${dir}/p2/do2.txt"


    # Find all directories that contains 'nothing.txt'. There should be none of that.
    ! _do_repo_dir_array_exists "do-test-gen" "t1" || _do_assert_fail
    _do_repo_dir_array_new "${proj_dir}" "do-test-gen" "t1" "nothing.txt" || _do_assert_fail

    _do_repo_dir_array_exists "do-test-gen" "t1" || _do_assert_fail
    _do_repo_dir_array_is_empty "do-test-gen" "t1" || _do_assert_fail


    # Find all directories that contains '*.txt'. There should be two of that.
    ! _do_repo_dir_array_exists "do-test-gen" "t2" || _do_assert_fail
    _do_repo_dir_array_new "${proj_dir}" "do-test-gen" "t2" "*.txt" || _do_assert_fail

    _do_repo_dir_array_exists "do-test-gen" "t2" || _do_assert_fail
    ! _do_repo_dir_array_is_empty "do-test-gen" "t2" || _do_assert_fail
    _do_repo_dir_array_print "do-test-gen" "t2" || _do_assert_fail
}
