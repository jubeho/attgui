import std/[strformat,strutils,unicode,uri,os]
import niup/niupc
import niup/niupext

var
  filesDroped: seq[string] = @[]
  itemsSelection: seq[bool] = @[]
  isNewFileDrop: bool = true

proc makeFilesGbox(files: seq[string])
  
proc cb_btn_quit(ih: PIhandle): cint {.cdecl.} =
  IUP_CLOSE

proc cb_btns_files(ih: PIhandle):cint {.cdecl.} =
  echo $GetAttribute(ih, "NAME")
  IUP_DEFAULT

proc cb_gbox_files_dropfiles(ih: PIhandle, filename: cstring, num, x, y: cint):cint {.cdecl.} =
  if isNewFileDrop:
    filesDroped = @[]
    isNewFileDrop = false
  let fp = decodeUrl($filename)
  filesDroped.add(fp)
  if num > 0:
    IUP_CONTINUE
  else:
    echo filesDroped
    makeFilesGbox(filesDroped)
    isNewFileDrop = true
    IUP_DEFAULT

proc makeFilesGbox(files: seq[string])=
  var frm = GetHandle("frm_files")
  var vbox = GetHandle("vbox_files")
  let dlg = GetHandle("dlg")
  var vbox_child = GetChild(vbox, 1)
  if vbox_child != nil:
    Destroy(vbox_child)
    Refresh(vbox)
    Refresh(dlg)
  var gbox = GridBox(
    nil,
  )
  SetAttribute(gbox, "NUMDIV", "2")
  SetAttribute(gbox, "MARGIN", "2x2")
  SetAttribute(gbox, "GAPLIN", "5")
  SetAttribute(gbox, "GAPCOL", "5")
  SetAttribute(gbox, "SIZECOL", "0")
  SetAttribute(gbox, "SIZELIN", "-1")
  SetAttribute(gbox, "ALIGNMENTLIN", "ACENTER")
  SetAttribute(gbox, "NORMALIZESIZE", "HORIZONTAL")
  SetAttribute(gbox, "ALIGNMENTCOL0", "ALEFT")
  SetHandle("gbox_files", gbox)
  echo $GetAttribute(gbox, "NUMLIN")
  for fp in files:
    let (_, fn, ext) = splitFile(fp)
    let btn = FlatButton(cstring(fn))
    SetAttribute(btn, "NAME", cstring(fp))
    SetAttribute(btn, "TOGGLE", "YES")
    SetAttribute(btn, "ALIGNMENT", "ALEFT")
    SetAttribute(btn, "EXPAND", "HORIZONTAL")
    SetCallback(btn , "FLAT_ACTION", cb_btns_files)

    var txt = Text(nil)
    SetAttribute(txt, "EXPAND", "HORIZONTAL")
    SetHandle(cstring(fmt("txt_{fp}")), txt)
    SetAttribute(txt, "NAME", cstring(fp))
    gbox = Append(gbox, btn)
    gbox = Append(gbox, txt)
    Map(btn)
    Map(txt)
  Refresh(gbox)
  echo $GetAttribute(gbox, "NUMLIN")
  let scrollbox = ScrollBox(gbox)
  Map(gbox)
  Refresh(scrollbox)
  vbox = Append(vbox, scrollbox)
  Map(scrollbox)
  Refresh(vbox)
  Map(vbox)
  Refresh(frm)
  let zbox = GetHandle("zbox_files")
  SetAttribute(zbox, "VALUE", "frm_files")
  Refresh(zbox)
  Refresh(dlg)

proc cb_lbl_dropfiles_here(ih: PIhandle, filename: cstring, num, x, y: cint):cint {.cdecl.} =
  # let lbl_dropfiles_here = GetHandle("lbl_dropfiles_here")
  # SetAttribute(lbl_dropfiles_here, "VISIBLE", "NO")
  let fp = decodeUrl($filename)
  filesDroped.add(fp)
  if num > 0:
    IUP_CONTINUE
  else:
    echo filesDroped
    makeFilesGbox(filesDroped)
    IUP_DEFAULT

proc initGui*(args: seq[string])=
  if len(args) > 0:
    # ad.readInFiles(args)
    discard
  # niupext.Open()
  Open()
  ControlsOpen()
  SetGlobal("UTF8MODE", "YES")

  # --- LABELs ----------------------------------
  let lbl_header = Label("this is att")
  SetAttribute(lbl_header, "EXPAND", "HORIZONTAL")
  SetAttribute(lbl_header, "ALIGNMENT", "ACENTER:ACENTER")

  var lbl_dropfiles_here = FlatLabel("DROP FILES HERE")
  SetAttribute(lbl_dropfiles_here, "EXPAND", "YES")
  SetAttribute(lbl_dropfiles_here, "ALIGNMENT", "ACENTER:ACENTER")
  SetAttribute(lbl_dropfiles_here, "DROPFILESTARGET", "YES")
  SetCallback(lbl_dropfiles_here, "DROPFILES_CB", cb_lbl_dropfiles_here)
  # SetHandle("lbl_dropfiles_here", lbl_dropfiles_here)

  # --- TEXTs -----------------------------------

  # --- BUTTONs ---------------------------------
  let btn_quit = Button("quit", nil)
  SetAttribute(btn_quit, "EXPAND", "HORIZONTAL")
  SetCallback(btn_quit, "ACTION", cb_btn_quit)
  SetHandle("btn_quit", btn_quit)

  # --- OTHERs ----------------------------------

  # --- BOXs ------------------------------------
  let gbox_filesHeader = GridBox(
    SetAttributes(Label("Files..."), "FONTSTYLE=Bold,EXPAND=HORIZONTAL,ALIGNMENT=ACENTER"),
    SetAttributes(Label("---"), "FONTSTYLE=Bold,EXPAND=HORIZONTAL,ALIGNMENT=ACENTER"),
    nil,
  )
  SetAttribute(gbox_filesHeader, "NUMDIV", "2")
  SetAttribute(gbox_filesHeader, "MARGIN", "2x2")
  SetAttribute(gbox_filesHeader, "GAPLIN", "5")
  SetAttribute(gbox_filesHeader, "GAPCOL", "5")
  SetAttribute(gbox_filesHeader, "SIZECOL", "0")
  SetAttribute(gbox_filesHeader, "SIZELIN", "-1")
  SetAttribute(gbox_filesHeader, "ALIGNMENTLIN", "ACENTER")
  SetAttribute(gbox_filesHeader, "NORMALIZESIZE", "HORIZONTAL")
  SetAttribute(gbox_filesHeader, "ALIGNMENTCOL0", "ALEFT")

  let gbox_tagsHeader = GridBox(
    SetAttributes(Label("Tagname"), "FONTSTYLE=Bold,EXPAND=HORIZONTAL,ALIGNMENT=ACENTER"),
    SetAttributes(Label("Tagvalues"), "FONTSTYLE=Bold,EXPAND=HORIZONTAL,ALIGNMENT=ACENTER"),
    SetAttributes(Label("Action Buttons"), "FONTSTYLE=Bold,EXPAND=HORIZONTAL,ALIGNMENT=ACENTER"),
    nil,
  )
  SetAttribute(gbox_tagsHeader, "NUMDIV", "3")
  SetAttribute(gbox_tagsHeader, "MARGIN", "2x2")
  SetAttribute(gbox_tagsHeader, "GAPLIN", "5")
  SetAttribute(gbox_tagsHeader, "GAPCOL", "5")
  SetAttribute(gbox_tagsHeader, "SIZECOL", "0")
  SetAttribute(gbox_tagsHeader, "SIZELIN", "-1")
  SetAttribute(gbox_tagsHeader, "ALIGNMENTLIN", "ACENTER")
  SetAttribute(gbox_tagsHeader, "NORMALIZESIZE", "HORIZONTAL")
  SetAttribute(gbox_tagsHeader, "ALIGNMENTCOL0", "ALEFT")
  
  let vbox_files = Vbox(gbox_filesHeader, nil)
  SetHandle("vbox_files", vbox_files)

  let vbox_tags = Vbox(gbox_tagsHeader, nil)
  SetHandle("vbox_files", vbox_tags)

  # --- FRAMEs ----------------------------------
  var frm_files = Frame(vbox_files)
  SetAttribute(frm_files, "EXPAND", "YES")
  SetHandle("frm_files", frm_files)
  # SetAttribute(frm_files, "DROPFILESTARGET", "YES")
  # SetCallback(frm_files, "DROPFILES_CB", cb_gbox_files_dropfiles)

  var zbox_files = Zbox(lbl_dropfiles_here, frm_files, nil)
  SetHandle("zbox_files", zbox_files)
  
  var frm_tags = Frame(vbox_tags)
  SetAttribute(frm_tags, "EXPAND", "YES")

  # --- MAINLAYOUT ------------------------------

  let box_main = Vbox(
      lbl_header,
      zbox_files,
      frm_tags,
      btn_quit,
      nil
  )
  let dlg = Dialog(box_main)
  SetAttribute(dlg, "TITLE", "att - another tag tool")
  SetAttribute(dlg, "RASTERSIZE", "800x600")
  SetAttribute(dlg, "MARGIN", "5x5")
  # SetAttribute(dlg, "ICON", "att.ico")

  SetAttribute(dlg, "SHRINK", "YES")
  SetAttribute(dlg, "DROPFILESTARGET", "YES")
  SetCallback(dlg, "DROPFILES_CB", cb_gbox_files_dropfiles)

  SetHandle("dlg", dlg)
  
  Map(dlg)

  ShowXY(dlg, IUP_CENTER, IUP_CENTER)

  MainLoop()
  Close()

if isMainModule:
  initGui(@[])
