import { Grid } from '@material-ui/core';
import React, { PropsWithChildren } from 'react';
import {
  Content,
  ContentHeader,
  Header,
  InfoCard,
  Page,
} from '@backstage/core';

export default {
  title: 'DVP Portal Homepage',
  component: InfoCard,
};

const Wrapper = ({ children }: PropsWithChildren<{}>) => (
  <Grid container spacing={4}>
    <Grid item xs={4}>
      {children}
    </Grid>
  </Grid>
);

export const HomePage = () => (
  <Page themeId="home">
    <Header title="DVP Developer Portal Homepage" />
    <Content>
      {'cool stuff' && <ContentHeader title="more cool stuff" />}
      <Wrapper>
        <InfoCard title="Information Card" subheader="Subheader">
          'This is the home page'
        </InfoCard>
      </Wrapper>
    </Content>
  </Page>
);
