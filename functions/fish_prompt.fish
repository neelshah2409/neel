# name: Neel Shah
function fish_prompt
  set -l last_status $status

  set -l fish     ">>"
  set -l ahead    "↑"
  set -l behind   "↓"
  set -l diverged "⥄ "
  set -l dirty    "⨯"
  set -l none     "◦"

  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l green (set_color green)
  set -l red (set_color red)
  set -l brightred (set_color -o red)
  set -l blue (set_color -o blue)
  set -l normal (set_color normal)

  if [ $last_status != 0 ]
    set failed "$brightred✘$normal "
  end

  if [ 'root' = (whoami) ]
    set arrow "$brightred➜$normal  "
  else
    set arrow ''
  end
  
  if test "$theme_complete_path" = "yes"
		set cwd (prompt_pwd)
	else
		set cwd (basename (prompt_pwd))
	end
  set -l time $yellow(date '+%I:%M')$normal  
  set -l cwd $cyan$cwd$normal

  if [ (_git_branch_name) ]
    set -l git_branch_name (_git_branch_name)
    set -l git_branch $brightred$git_branch_name$normal
    set git_info "$blue ($git_branch$blue)$normal"
    set -l git_ahead_count (_git_ahead_count $git_branch_name)

    if [ $git_ahead_count != 0 ]
      set -l ahead_count "$green+$git_ahead_count$normal"
      set git_info "$git_info $ahead_count"
    end

    if [ (_is_git_dirty) ]
      set -l dirty "$yellow ✗$normal"
      set git_info "$git_info$dirty"
    end
  end

  echo -n -s $failed $arrow $time ' ' $cwd $git_info $normal ' '

  if [ $fish_key_bindings = fish_vi_key_bindings ]
        switch $fish_bind_mode
            case default
                set_color -b red
            case insert
                set_color -b green
            case visual
                set_color -b yellow
            case replace-one
                set_color -b magenta
        end
        echo -n " "
    end


end



function _git_branch_name
  echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function _git_ahead_count -a branch_name
  echo (command git log origin/$branch_name..HEAD 2> /dev/null | \
    grep '^commit' | wc -l | tr -d ' ')
end

