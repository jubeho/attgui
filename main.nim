# att - another tag tool
# i hope my last try :-P (said 16.05.2023)
###############################################################################

import std/[os,strformat,tables,strutils,logging]
import attgui

import argparse

var p = newParser:
  help("att - another tag tool... to tag tagable things :-p ...")
  flag("-v", "--version", help="shows application version")
  command("gui"):
    arg("dirsfiles", help="dir(s) and/or file(s) to list tags from", nargs = -1)

proc guiCmd(args: seq[string]) =
  # initGui(args)
  initGui(args)

when isMainModule:
  echo("hey - this is att - hope you enjoy it!")
  #log.log(lvlInfo, "a info log message")
  try:
    let opts = p.parse()

    if opts.command == "gui":
      var args: seq[string] = @[]
      # var args: seq[string] = @["."]
      if len(opts.gui.get.dirsfiles) > 0 :
        args = @[]
        args.add(opts.gui.get.dirsfiles)
      guiCmd(args)

  except ShortCircuit as err:
    if err.flag == "argparse_help":
      echo err.help
      quit()
  except UsageError:
    stderr.writeLine getCurrentExceptionMsg()
    quit(1)

