let print_and_wait message =
  print_string message;
  let (_:string) = read_line () in ()

let payload = Rrd_protocol.({
  timestamp = 0L;
  datasources = [];
})

let create_reader () =
  print_and_wait "start of create_reader";
  let path = "/tmp/memory_check_shared_file" in
  let reader = Rrd_reader.FileReader.create path Rrd_protocol_v2.protocol in
  print_and_wait "end of create_reader";
  reader

let main () =
  print_and_wait "start of main";
  let reader = create_reader () in
  print_and_wait "created reader";
  let (_:Rrd_protocol.payload) = reader.Rrd_reader.read_payload () in
  print_and_wait "read payload";
  Gc.minor ();
  print_and_wait "Gc.minor done";
  Gc.major ();
  print_and_wait "Gc.major done";
  reader.Rrd_reader.cleanup ();
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
