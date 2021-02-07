#!/usr/bin/env bash

if [[ -f "${CONFIG_PATH}" ]]; then
    # Hass.IO configuration
    profile_name="$(jq --raw-output '.profile_name' "${CONFIG_PATH}")"
    profile_dir="$(jq --raw-output '.profile_dir' "${CONFIG_PATH}")"
    RHASSPY_ARGS=('--profile' "${profile_name}" '--user-profiles' "${profile_dir}")

    # Copy user-defined asoundrc to root
    asoundrc="$(jq --raw-output '.asoundrc' "${CONFIG_PATH}")"
    if [[ -n "${asoundrc}" ]]; then
        echo "${asoundrc}" > /root/.asoundrc
    fi
fi

if [[ -z "${RHASSPY_ARGS[*]}" ]]; then
    /usr/lib/rhasspy/bin/rhasspy-voltron
else
    /usr/lib/rhasspy/bin/rhasspy-voltron "${RHASSPY_ARGS[@]}"
fi
