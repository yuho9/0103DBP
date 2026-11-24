package com.campusmatching.controller;

import java.util.List;

import com.campusmatching.model.domain.Category;
import com.campusmatching.model.domain.Project;
import com.campusmatching.model.domain.Tag;

public class ProjectCard {
    private final Project project;
    private final Category category;
    private final List<Tag> tags;
    private final int activeMemberCount;
    private final int scrapCount;
    private final boolean scrapped;

    public ProjectCard(Project project, Category category, List<Tag> tags,
                       int activeMemberCount, int scrapCount, boolean scrapped) {
        this.project = project;
        this.category = category;
        this.tags = tags;
        this.activeMemberCount = activeMemberCount;
        this.scrapCount = scrapCount;
        this.scrapped = scrapped;
    }

    public Project getProject() { return project; }
    public Category getCategory() { return category; }
    public List<Tag> getTags() { return tags; }
    public int getActiveMemberCount() { return activeMemberCount; }
    public int getScrapCount() { return scrapCount; }
    public boolean isScrapped() { return scrapped; }
}
