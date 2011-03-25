module IOOpen
   # This lets us get STDIN/OUT/ERR from a process, in the traditional UNIX way of doing such things.
   #
   # You might cause zombie processes if you SIGKILL the script while in this block. How?
   # waitpid is the one that reaps children after they terminate. if it doesn't run, the child
   # will be left in zombie state after it completes if the parent was SIGKILLed. For this reason,
   # use SIGINT to terminate the script if possible. this will trigger a ruby exception, and
   # that will  "ensure" that your children don't become zombies.
   #
   # Nobody wants zombie children.
   #
   def io_open(*cmd)
      pw = IO::pipe   # pipe[0] for read, pipe[1] for write
      pr = IO::pipe
      pe = IO::pipe

      pid = fork do
         pw[1].close
         STDIN.reopen pw[0]
         pw[0].close

         pr[0].close
         STDOUT.reopen pr[1]
         pr[1].close

         pe[0].close
         STDERR.reopen pe[1]
         pe[1].close

         exec *cmd
      end

      pw[0].close; pr[1].close; pe[1].close
      pw[1].sync = true
      pi = [pw[1], pr[0], pe[0]]
      begin
         # Folks can interact with the process here, providing input and gathering output
         raise "Block is required" unless defined? yield
         return yield(*pi)
      ensure
         # wait, so that at the end of the block, $? is filled in
         Process.waitpid(pid)
         pi.each{|p| p.close unless p.closed?}
      end
   end

   # Many commands expect no input, and just write output. Oblige them with an entrypoint
   def o_open(*cmd)
      io_open(*cmd) do |i,o,e|
         i.close
         yield [o,e]
      end
   end

end

