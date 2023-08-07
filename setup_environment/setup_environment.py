import os
import pathlib
import subprocess


def set_env_variable(env_variable, env_variable_name):
    """This function will set environment variables for windows if not already
    set. Note that this sets directories to use unix style path separators so
    the environment variables are only good in programs that recognize that
    format.

    Parameters
    ----------
    env_variable : str
        This is what the environment variable will go by in the code.
    env_variable_name : str
        This is the human readable name for the environment variable.
    """

    if os.getenv(env_variable) is None:
        env_variable_path = pathlib.Path(input(f"What is the path to the {env_variable_name} on "
                                               "this computer?:  "))
        if env_variable_path.is_dir():
            env_variable_path = str(env_variable_path).replace("\\", "/")
            subprocess.Popen(f'setx {env_variable} "{env_variable_path}"')


if __name__ == "__main__":
    env_variables = [("NOTES_DIR", "notes directory"),
                     ("MILAM_NOTES_REPO_DIR", "milam notes repository"),
                     ("GIT_REPOS", "git repositories")]
    for env_variable in env_variables:
        set_env_variable(*env_variable)
