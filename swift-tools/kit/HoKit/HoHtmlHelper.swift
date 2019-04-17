//
//  HoHtmlHelper.swift
//  swift-tools
//
//  Created by 叶长生 on 2019/4/17.
//  Copyright © 2019 Hoa. All rights reserved.
//
import UIKit

struct HoHtmlHelper {
    
    
    /// Html适配
    ///
    /// - parameter htmlStr: body html未能适配屏幕的html字符串
    /// - returns: 添加适配后的html string
    static func adaptWebViewForHtml(htmlStr: String) -> String {
        let headHtml = NSMutableString(capacity: 0)
        
        headHtml.append("<head>")
        
        headHtml.append("<meta charset=\"utf-8\">")
        
        headHtml.append("<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />")
        
        headHtml.append("<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />")
        
        headHtml.append("<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />")
        
        headHtml.append("<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />")
        
        //适配图片宽度，让图片宽度等于屏幕宽度
        headHtml.append("<style>img{width:100%;}</style>")
        headHtml.append("<style>img{height:auto;}</style>")
        
        
        //适配图片宽度，让图片宽度最大等于屏幕宽度
        headHtml.append("<style>img{max-width:100%;width:auto;height:auto;}</style>")
        
        //适配图片宽度，如果图片宽度超过手机屏幕宽度，就让图片宽度等于手机屏幕宽度，高度自适应，如果图片宽度小于屏幕宽度，就显示图片大小
        headHtml.append("<script type='text/javascript'>" +
            "window.onload = function(){\n" +
            "var maxwidth=document.body.clientWidth;\n" + //屏幕宽度
            "for(i=0;i <document.images.length;i++){\n" +
            "var myimg = document.images[i];\n" +
            "if(myimg.width > maxwidth){\n" +
            "myimg.style.width = '100%';\n" +
            "myimg.style.height = 'auto'\n;" +
            "}\n" +
            "}\n" +
            "}\n" +
            "</script>\n")
        
        headHtml.append("<style>table{width:100%;}</style>")
        headHtml.append("<title>webview</title>")
        
        var bodyHtml: String = headHtml as String
        bodyHtml += htmlStr
        return bodyHtml;
    }
}
