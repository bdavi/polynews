'use strict';

const pageHasStoryGrid = () => {
  return !!document.querySelector('#story-grid');
};

const lowEnoughToLoadNextPage = () => {
  const { clientHeight, scrollHeight, scrollTop } = document.documentElement;

  return scrollTop + clientHeight > scrollHeight - 20
};

const nextPageUrl = () => {
  const lastPageDataElement = Array.from(
    document.querySelectorAll('.story-grid-page-data')
  ).pop();

  return lastPageDataElement
         && lastPageDataElement.getAttribute('data-next-page-url');
};

const shouldLoadNextPage = () => {
  return pageHasStoryGrid() && lowEnoughToLoadNextPage()
         && nextPageUrl() && !isLoading();
};

const loadingIndicatorElement = () => {
  return document.querySelector('#story-grid-loading-indicator');
};

const isLoading = () => {
  return loadingIndicatorElement().style.display === 'flex';
};

const loadNextPage = async () => {
  loadingIndicatorElement().style.display = 'flex';
  $.getScript(nextPageUrl());
};

// Sometimes a viewport will be too tall to properly activate the infinite
// scroll. Automatically grab the second page to make sure.
$(document).on('turbolinks:load', function() {
  loadNextPage();
});

window.addEventListener('scroll', () => {
  if (shouldLoadNextPage()) {
    loadNextPage();
  }
});
