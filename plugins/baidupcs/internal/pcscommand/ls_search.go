package pcscommand

import (
	"fmt"
	"github.com/felixonmars/BaiduPCS-Go/baidupcs"
	"github.com/felixonmars/BaiduPCS-Go/pcstable"
	"github.com/felixonmars/BaiduPCS-Go/pcsutil/converter"
	"github.com/felixonmars/BaiduPCS-Go/pcsutil/pcstime"
	"github.com/olekukonko/tablewriter"
	"os"
    "io/ioutil"
	"github.com/json-iterator/go"
	"strconv"
)

type (
	// LsOptions 列目录可选项
	LsOptions struct {
		Total bool
	}

	// SearchOptions 搜索可选项
	SearchOptions struct {
		Total   bool
		Recurse bool
	}

    Bai struct {
        File  map[string]string
        Dir map[string]interface{}
    }
)

const (
	opLs int = iota
	opSearch
)

// RunLs 执行列目录
func RunLs(pcspath string, lsOptions *LsOptions, orderOptions *baidupcs.OrderOptions) {
	err := matchPathByShellPatternOnce(&pcspath)
	if err != nil {
		fmt.Println(err)
		return
	}

	files, err := GetBaiduPCS().FilesDirectoriesList(pcspath, orderOptions)
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Printf("\n当前目录: %s\n----\n", pcspath)

	if lsOptions == nil {
		lsOptions = &LsOptions{}
	}

	renderTable(opLs, lsOptions.Total, pcspath, files)
	return
}

func check(e error) {
    if e != nil {
        panic(e)
    }
}

func GetAll(pcspath string, dir1 *Bai, orderOptions *baidupcs.OrderOptions, depth int) {
    var (
        err   error
        files baidupcs.FileDirectoryList
    )
    if depth == 0 {
        err := matchPathByShellPatternOnce(&pcspath)
        if err != nil {
            fmt.Println(err)
            return
        }
    }

    files, err = GetBaiduPCS().FilesDirectoriesList(pcspath, orderOptions)
    if err != nil {
        fmt.Println(err)
        return
    }

    for i, file := range files {
        if file.Isdir {
            var dir2 Bai
            if (len(dir1.Dir) == 0) {
                dir1.Dir = make(map[string]interface{})
            }
            dir1.Dir[file.Filename] = &dir2
            GetAll(file.Path, &dir2, orderOptions, depth+1)
            continue
        }

        if (i >= 0) {
            if (len(dir1.File) == 0) {
                dir1.File = make(map[string]string)
            }
            // fmt.Printf("file: " + file.Filename + " " + converter.ConvertFileSize(file.Size, 2) + " \n")
            dir1.File[file.Filename] = converter.ConvertFileSize(file.Size, 2)
        }
    }

    return
}

func GenJS(output string, dir *Bai) {

    b, err :=  jsoniter.MarshalIndent(dir, "", " ")
    if err != nil{
        fmt.Println("error: ", err)
    }
    // os.Stdout.Write(b)
    // fmt.Println()

    err2 := ioutil.WriteFile(output + ".json", b, 0644) //写入文件(字节数组)
    check(err2)

    return
}

func RunLa(pcspath string, output string, orderOptions *baidupcs.OrderOptions) {

    var dir1 Bai;
    if (len(output) == 0) {
        output = "out"
    }
    GetAll(pcspath, &dir1, orderOptions, 0);
    GenJS(output, &dir1);

	return
}

// RunSearch 执行搜索
func RunSearch(targetPath, keyword string, opt *SearchOptions) {
	err := matchPathByShellPatternOnce(&targetPath)
	if err != nil {
		fmt.Println(err)
		return
	}

	if opt == nil {
		opt = &SearchOptions{}
	}

	files, err := GetBaiduPCS().Search(targetPath, keyword, opt.Recurse)
	if err != nil {
		fmt.Println(err)
		return
	}

	renderTable(opSearch, opt.Total, targetPath, files)
	return
}

func renderTable(op int, isTotal bool, path string, files baidupcs.FileDirectoryList) {
	tb := pcstable.NewTable(os.Stdout)
	var (
		fN, dN   int64
		showPath string
	)

	switch op {
	case opLs:
		showPath = "文件(目录)"
	case opSearch:
		showPath = "路径"
	}

	if isTotal {
		tb.SetHeader([]string{"#", "fs_id", "app_id", "文件大小", "创建日期", "修改日期", "md5(截图请打码)", showPath})
		tb.SetColumnAlignment([]int{tablewriter.ALIGN_DEFAULT, tablewriter.ALIGN_RIGHT, tablewriter.ALIGN_RIGHT, tablewriter.ALIGN_LEFT, tablewriter.ALIGN_LEFT, tablewriter.ALIGN_LEFT, tablewriter.ALIGN_LEFT})
		for k, file := range files {
			if file.Isdir {
				tb.Append([]string{strconv.Itoa(k), strconv.FormatInt(file.FsID, 10), strconv.FormatInt(file.AppID, 10), "-", pcstime.FormatTime(file.Ctime), pcstime.FormatTime(file.Mtime), file.MD5, file.Filename + baidupcs.PathSeparator})
				continue
			}

			var md5 string
			if len(file.BlockList) > 1 {
				md5 = "(可能不正确)" + file.MD5
			} else {
				md5 = file.MD5
			}

			switch op {
			case opLs:
				tb.Append([]string{strconv.Itoa(k), strconv.FormatInt(file.FsID, 10), strconv.FormatInt(file.AppID, 10), converter.ConvertFileSize(file.Size, 2), pcstime.FormatTime(file.Ctime), pcstime.FormatTime(file.Mtime), md5, file.Filename})
			case opSearch:
				tb.Append([]string{strconv.Itoa(k), strconv.FormatInt(file.FsID, 10), strconv.FormatInt(file.AppID, 10), converter.ConvertFileSize(file.Size, 2), pcstime.FormatTime(file.Ctime), pcstime.FormatTime(file.Mtime), md5, file.Path})
			}
		}
		fN, dN = files.Count()
		tb.Append([]string{"", "", "总: " + converter.ConvertFileSize(files.TotalSize(), 2), "", "", "", fmt.Sprintf("文件总数: %d, 目录总数: %d", fN, dN)})
	} else {
		tb.SetHeader([]string{"#", "文件大小", "修改日期", showPath})
		tb.SetColumnAlignment([]int{tablewriter.ALIGN_DEFAULT, tablewriter.ALIGN_RIGHT, tablewriter.ALIGN_LEFT, tablewriter.ALIGN_LEFT})
		for k, file := range files {
			if file.Isdir {
				tb.Append([]string{strconv.Itoa(k), "-", pcstime.FormatTime(file.Mtime), file.Filename + baidupcs.PathSeparator})
				continue
			}

			switch op {
			case opLs:
				tb.Append([]string{strconv.Itoa(k), converter.ConvertFileSize(file.Size, 2), pcstime.FormatTime(file.Mtime), file.Filename})
			case opSearch:
				tb.Append([]string{strconv.Itoa(k), converter.ConvertFileSize(file.Size, 2), pcstime.FormatTime(file.Mtime), file.Path})
			}
		}
		fN, dN = files.Count()
		tb.Append([]string{"", "总: " + converter.ConvertFileSize(files.TotalSize(), 2), "", fmt.Sprintf("文件总数: %d, 目录总数: %d", fN, dN)})
	}

	tb.Render()

	if fN+dN >= 50 {
		fmt.Printf("\n当前目录: %s\n", path)
	}

	fmt.Printf("----\n")
}
