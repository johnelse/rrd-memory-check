let print_and_wait message =
  print_string message;
  let (_:string) = read_line () in ()

let payload = Rrd_protocol.({
  timestamp = 0L;
  datasources = [];
})

let create_writer () =
  print_and_wait "start of create_writer";
  let id = Rrd_writer.({
    path = "/tmp/memory_check_shared_file";
    shared_page_count = 1024;
  }) in
  let _, writer = Rrd_writer.FileWriter.create id Rrd_protocol_v2.protocol in
  print_and_wait "end of create_writer";
  writer

let main () =
  print_and_wait "start of main";
  let writer = create_writer () in
  print_and_wait "created writer";
  writer.Rrd_writer.write_payload payload;
  print_and_wait "wrote payload";
  Gc.minor ();
  print_and_wait "Gc.minor done";
  Gc.major ();
  print_and_wait "Gc.major done";
  writer.Rrd_writer.cleanup ();
  print_and_wait "cleaned up";
  print_and_wait "end of main"

let () =
  print_and_wait "start of program";
  main ();
  print_and_wait "returned from main";
  Gc.minor ();
  print_and_wait "Gc.minor done";
  Gc.major ();
  print_and_wait "Gc.major done";
  print_and_wait "done"
