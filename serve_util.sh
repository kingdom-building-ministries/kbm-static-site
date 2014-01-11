#!/usr/bin/expect

set timeout -1

spawn rake serve

trap {
    send_user "Ouch! Terminating"
    set process_id [exp_pid]
    exec kill -9 $process_id
    close
    wait
    exit
} SIGINT

set notify_settings "-title \"Jekyll Server\" -group \"org.kbm.jekyll\" -activate com.apple.Terminal"
set error_sound "-sound \"Sosumi\""
expect "Generating..." { exec bundle exec terminal-notifier -message "Server Starting" {*}$notify_settings }
expect "Server running" { exec bundle exec terminal-notifier -message "Server Running" {*}$notify_settings }

while { 1 } {
    expect {
       "Regenerating:" { exec bundle exec terminal-notifier -message "Regen Starting" {*}$notify_settings }
    }
    expect {
       "...done." { exec bundle exec terminal-notifier -message "Regen Done" {*}$notify_settings }
       "Listen warning" { exec bundle exec terminal-notifier -message "ERROR ERROR" {*}$error_sound {*}$notify_settings }
       "Sass failed generating" { exec bundle exec terminal-notifier -message "SASS ERROR" {*}$error_sound {*}$notify_settings }
    }
}

exit
