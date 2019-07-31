package com.kh.myhouse.admin.model.vo;

import javax.xml.bind.annotation.XmlElement;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@ToString
public class Item {
	private String title;
	private String link;
	private String description;
	private String pubDate;
	private String author;
	private String category;
	
	@XmlElement
	public void setTitle(String title) {
		this.title = title;
	}
	@XmlElement
	public void setLink(String link) {
		this.link = link;
	}
	@XmlElement
	public void setDescription(String description) {
		this.description = description;
	}
	@XmlElement
	public void setPubDate(String pubDate) {
		this.pubDate = pubDate;
	}
	@XmlElement
	public void setAuthor(String author) {
		this.author = author;
	}
	@XmlElement
	public void setCategory(String category) {
		this.category = category;
	}
	
	
}
