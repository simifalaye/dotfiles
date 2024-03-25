#!/usr/bin/python
from ansible.module_utils.basic import AnsibleModule
import os


def remove_dead_links(dir, result):
    # Check for dead symlinks in dir
    for item in os.listdir(dir):
        full_path = os.path.join(dir, item)
        if os.path.islink(full_path) and not os.path.exists(full_path):
            os.unlink(full_path)
            result["changed"] = True


def link_files(src_dir, base_dir):
    result = {"changed": False, "linked_files": [], "backup_files": []}

    # Install symlinks
    for root, _, files in os.walk(src_dir):
        for file in files:
            src_file = os.path.join(root, file)
            rel_path = os.path.relpath(src_file, src_dir)
            dest_file = os.path.join(base_dir, rel_path)
            dest_dir = os.path.dirname(dest_file)

            os.makedirs(dest_dir, exist_ok=True)
            remove_dead_links(dest_dir, result)

            if os.path.lexists(dest_file):
                if os.path.islink(dest_file) and os.path.realpath(
                    dest_file
                ) == os.path.realpath(src_file):
                    # Symlink points to the same source file
                    continue
                else:
                    # Backup existing file/symlink
                    backup_file = f"{dest_file}.backup"
                    os.rename(dest_file, backup_file)
                    result["backup_files"].append(
                        {"src": dest_file, "dest": backup_file}
                    )

            os.symlink(src_file, dest_file)
            result["changed"] = True
            result["linked_files"].append({"src": src_file, "dest": dest_file})
            print(f"Created Link: {src_file} => {dest_file}")

    return result


def main():
    module_args = dict(
        src_dir=dict(type="str", required=True),
        base_dir=dict(type="str", default=os.environ.get("HOME", "")),
    )
    module = AnsibleModule(argument_spec=module_args, supports_check_mode=True)
    src_dir = module.params["src_dir"]
    base_dir = module.params["base_dir"]

    if not os.path.isdir(src_dir):
        module.fail_json(msg=f"{src_dir} is not a directory")
    if not os.path.isdir(base_dir):
        module.fail_json(msg=f"{base_dir} is not a directory")
    try:
        result = link_files(src_dir, base_dir)
        module.exit_json(**result)
    except Exception as e:
        module.fail_json(msg=str(e))


if __name__ == "__main__":
    main()
