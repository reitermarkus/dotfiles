task :ansible do
  # Ensure SSH control path does not have spaces.
  ansible_ssh_control_path_dir = '~/.cache/ansible/cp'

  add_line_to_file fish_environment, "set -x ANSIBLE_SSH_CONTROL_PATH_DIR #{ansible_ssh_control_path_dir}"
  add_line_to_file bash_environment, "export ANSIBLE_SSH_CONTROL_PATH_DIR=#{ansible_ssh_control_path_dir}"
end
