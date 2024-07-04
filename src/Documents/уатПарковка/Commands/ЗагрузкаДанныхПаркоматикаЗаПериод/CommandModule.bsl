
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Обработчик = Новый ОписаниеОповещения("ЗагрузитьПарковкиЗавершение", ЭтотОбъект, ПараметрыВыполненияКоманды.Источник);
	ПараметрыОткрытияФормы = Новый Структура();
	ПараметрыОткрытияФормы.Вставить("Заголовок", Нстр("ru = 'Выберите учетную запись'"));
	ПараметрыОткрытияФормы.Вставить("Отбор", Новый Структура("ВнешняяСистема",
		ПредопределенноеЗначение("Справочник.уатВнешниеСистемы.Паркоматика")));
	ОткрытьФорму("Справочник.уатУчетныеЗаписиСервисовПарковок.ФормаВыбора", ПараметрыОткрытияФормы, ПараметрыВыполненияКоманды.Источник,,,,Обработчик);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьПарковкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийПериод = Новый СтандартныйПериод;
	
	Обработчик    = Новый ОписаниеОповещения("ЗагрузитьПарковкиЗавершениеПериод", ЭтотОбъект,
		Новый Структура("УчетнаяЗапись, ДополнительныеПараметры", Результат, ДополнительныеПараметры));
	Диалог        = Новый ДиалогРедактированияСтандартногоПериода;
	Диалог.Период = ТекущийПериод;
	Диалог.Показать(Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПарковкиЗавершениеПериод(Результат, ДопПараметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаНачала    = НачалоДня(Результат.ДатаНачала);
	ДатаОкончания = НачалоДня(Результат.ДатаОкончания);
		
	Загружено   = 0;
	ЗагрузитьПарковкиЗавершениеСервер(ДопПараметры.УчетнаяЗапись, ДатаНачала, ДатаОкончания, Загружено, ДопПараметры.ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПарковкиЗавершениеСервер(Результат, ДатаНачала, ДатаОкончания, Загружено = 0, ФормаВладелец)
	
	ТекстОшибки = "";

	ДлительнаяОперация = ЗагрузитьПарковкиЗавершениеДлительнаяОперацияСервер(Результат, ДатаНачала, ДатаОкончания, ТекстОшибки);
	
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ФормаВладелец);
	НастройкиОжидания.ВыводитьОкноОжидания       = Истина;
	НастройкиОжидания.ВыводитьПрогрессВыполнения = Истина;

	Обработчик = Новый ОписаниеОповещения("ЗагрузитьПарковкиЗавершениеДлительнаяОперацияЗавершение", ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Обработчик, НастройкиОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПарковкиЗавершениеДлительнаяОперацияЗавершение(Операция, ДополнительныеПараметры) Экспорт
	
	Если Операция = Неопределено Тогда
		
	Иначе
		Если Операция.Статус = "Выполнено" Тогда
			Если ЭтоАдресВременногоХранилища(Операция.АдресРезультата) Тогда
				Данные = ПолучитьИзВременногоХранилища(Операция.АдресРезультата);
				Если ТипЗнч(Данные) = Тип("Структура") Тогда
					Если Данные.Свойство("ТекстОшибки") Тогда
						Если ЗначениеЗаполнено(Данные.ТекстОшибки) Тогда
							ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Данные.ТекстОшибки);
							Возврат;
						Иначе
							ОповеститьОбИзменении(Тип("ДокументСсылка.уатПарковка"));
						КонецЕсли;
					КонецЕсли;
					
				КонецЕсли;
			КонецЕсли;
		Иначе
			ВызватьИсключение Операция.КраткоеПредставлениеОшибки;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьПарковкиЗавершениеДлительнаяОперацияСервер(УчетнаяЗапись, ДатаНачала, ДатаОкончания, ТекстОшибки)
	
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка парковок'");
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;

	Возврат ДлительныеОперации.ВыполнитьВФоне(
	"уатИнтеграции_проф.Паркоматика_СписокПарковочныхСессийДлительнаяОперация",
	Новый Структура("УчетнаяЗапись, ДатаНачала, ДатаОкончания", УчетнаяЗапись, ДатаНачала, ДатаОкончания),
	ПараметрыВыполнения);
	
КонецФункции

#КонецОбласти