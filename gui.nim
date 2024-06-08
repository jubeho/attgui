import niup/niupc
import niup/niupext

proc cb_dlg_drop(ih: PIhandle, file: cstring, num,x,y,: cint):cint {.cdecl.} =
  echo file
  return IUP_CONTINUE


proc cb_btn_quit(ih: PIhandle):cint {.cdecl.} =
  IUP_CLOSE

proc initGui*(args: seq[string])=
  # echo ad.metadataMappingId3v23
  if len(args) > 0:
    discard
  Open()
  ControlsOpen()
  SetGlobal("UTF8MODE", "YES")

  # [[ CONTROLS  ]]
  let
    lbl_header = Label("this is att")
    btn_quit = Button("quit", nil)

  # [[ CALLBACKS ]]
  SetCallback(btn_quit, "ACTION", cb_btn_quit)

  SetAttribute(lbl_header, "EXPAND", "HORIZONTAL")
  SetAttribute(lbl_header, "ALIGNMENT", "ACENTER:ACENTER")

  SetAttribute(btn_quit, "EXPAND", "HORIZONTAL")
  SetAttribute(btn_quit, "MARGIN", "10x10")



  let box_main = Vbox(
      lbl_header,
      btn_quit,
      nil
  )


  # [[ main window ]]
  let dlg = Dialog(box_main)
  SetAttribute(dlg, "TITLE", "att - another tag tool")
  # SetAttribute(dlg, "MARGIN", "5x5")
  # SetAttribute(dlg, "FONT", "Helvetica, 8")
  # SetAttribute(dlg, "SIZE", "HALFxHALF")
  SetAttribute(dlg, "RASTERSIZE", "800x600")
  SetAttribute(dlg, "ICON", "att.ico")
  SetCallback(dlg, "DROPFILES_CB", cb_dlg_drop)
  SetHandle("dlg", dlg)

  SetAttribute(dlg, "SHRINK", "YES")

  Map(dlg)
  ShowXY(dlg, IUP_CENTER, IUP_CENTER)

  MainLoop()
  Close()

if isMainModule:
  initGui(@[])
