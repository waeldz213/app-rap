import { createBrowserRouter } from 'react-router';
import Root from './pages/Root';
import Home from './pages/Home';
import Onboarding from './pages/Onboarding';
import PackSelection from './pages/PackSelection';
import SoloQuiz from './pages/SoloQuiz';
import Duel from './pages/Duel';
import Collection from './pages/Collection';
import Profile from './pages/Profile';
import Paywall from './pages/Paywall';
import DailyChallenge from './pages/DailyChallenge';

export const router = createBrowserRouter([
  {
    path: '/',
    element: <Root />,
    children: [
      { index: true, element: <Home /> },
      { path: 'onboarding', element: <Onboarding /> },
      { path: 'packs', element: <PackSelection /> },
      { path: 'solo/:packId', element: <SoloQuiz /> },
      { path: 'duel/:packId', element: <Duel /> },
      { path: 'collection', element: <Collection /> },
      { path: 'profile', element: <Profile /> },
      { path: 'paywall', element: <Paywall /> },
      { path: 'daily-challenge', element: <DailyChallenge /> },
    ],
  },
]);
