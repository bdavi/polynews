'use strict';

// #############################################################################
// DOM
// #############################################################################
const storyGridElement = () => {
  return document.querySelector('#story-grid');
};

const pageHasStoryGrid = () => {
  return !!storyGridElement();
};

const pageDataElements = () => {
  return storyGridElement().querySelectorAll('.story-grid-page-data');
}

const lastPageDataElement = () => {
  return Array.from(pageDataElements()).pop();
}

const loadingIndicatorElement = () => {
  return document.querySelector('#story-grid-loading-indicator');
};

const nextPageUrl = () => {
  return lastPageDataElement().getAttribute('data-next-page-url');
};


// #############################################################################
// Predicates
// #############################################################################
const lowEnoughToLoadNextPage = () => {
  const { clientHeight, scrollHeight, scrollTop } = document.documentElement;
  return scrollTop + clientHeight > scrollHeight - 20
};

const isLoading = () => {
  return loadingIndicatorElement().style.display === 'flex';
};

const shouldLoadNextPage = () => {
  return lowEnoughToLoadNextPage() && nextPageUrl() && !isLoading();
};


// #############################################################################
// Helpers
// #############################################################################
const showLoadingIndicator = () => {
  loadingIndicatorElement().style.display = 'flex';
};

const hideLoadingIndicator = () => {
  loadingIndicatorElement().style.display = 'none';
};

const loadNextPage = () => {
  showLoadingIndicator();
  $.getScript(nextPageUrl());
};

const loadInitialStories = () => {
  if (nextPageUrl() && !isLoading()) {
    loadNextPage();
  }
};


// #############################################################################
// Event Handling
// #############################################################################
const handleStoryGridScrolling = () => {
  if (shouldLoadNextPage()) {
    loadNextPage();
  }
};

const handleTurbolinksLoad = () => {
  if (pageHasStoryGrid()) {
    loadInitialStories();
    document.addEventListener('scroll', handleStoryGridScrolling);
  } else {
    document.removeEventListener('scroll', handleStoryGridScrolling);
  }
};

document.addEventListener('turbolinks:load', handleTurbolinksLoad);
