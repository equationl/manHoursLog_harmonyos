import commonDBViewModel from '../../common/viewmodel/CommonDBViewModel'
import preferencesHelper from '../../utill/PreferencesHelper'
import { LogComponent } from '../log/LogComponent'
import { StatisticComponent } from '../statistic/StatisticComponent'

@Entry
@Component
struct HomePage {
  @State checkedIndex: number = 0
  private tabController: TabsController = new TabsController()

  aboutToAppear(): void {
    this.init(getContext(this))
  }

  build() {
    Stack() {
      Tabs({
        index: this.checkedIndex,
        barPosition: BarPosition.End,
        controller: this.tabController,
      }) {
        TabContent() {
          // TODO
          LogComponent()
        }
        .tabBar("Log")

        TabContent() {
          // TODO
          StatisticComponent()
        }
        .tabBar("Statistic")
      }
      //.scrollable(false)
      .onChange((index: number) => {
        this.checkedIndex = index
      })
    }
    .width('100%')
    .height('100%')
  }

  private async init(context: Context) {
    console.log("el, call init from HomePage")
    await preferencesHelper.init(context)
    await commonDBViewModel.init(context)
  }

}