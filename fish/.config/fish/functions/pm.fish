function pm --description "process manager"
  set -l cmd (string trim -- $argv[1])
  set -l idx (string trim -- $argv[2])

  set -l silence '> /dev/null 2>&1 &'
  switch $cmd
    case "start"
      eval "$idx $silence"
      echo "Job started: $idx"
    case "stop"
      kill %$idx
      echo "Job stopped: %$idx"
    case "restart"
      set -l pattern ''"$idx"
      set -l command (jobs | sort | awk '$1 == '"$idx"' { cmd = ""; for (i = 4; i <= NF; i++) { if ($i == ">") break; cmd = cmd " " $i; } print cmd }')
      set -l command (string trim command)
      kill %$idx
      eval "$command $silence"
      echo "Job restarted: \"$command\""
      jobs
    case '*'
      echo "Usage: jm start \"command\" | stop job_index | restart job_index"
  end
end

