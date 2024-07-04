#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает макет со схемой получения данных.
//
// Параметры:
//  ХозяйственнаяОперация	 - 	 - 
// 
// Возвращаемое значение:
//   - 
//
Функция СхемаПолученияДанных(ХозяйственнаяОперация) Экспорт

	СхемаПолученияДанных = Неопределено;
	ИмяИсточникаДанных = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ХозяйственнаяОперация, "ИсточникДанных");
	МакетыИсточниковПолученияДанных = Метаданные.Справочники.НастройкиХозяйственныхОпераций.Макеты;
	МакетИсточникаПолученияДанных = МакетыИсточниковПолученияДанных.Найти(ИмяИсточникаДанных);
	Если МакетИсточникаПолученияДанных <> Неопределено Тогда
		ИмяСхемы = МакетИсточникаПолученияДанных.Имя; 
		СхемаПолученияДанных = Справочники.НастройкиХозяйственныхОпераций.ПолучитьМакет(ИмяСхемы);
	КонецЕсли;
	
	Возврат СхемаПолученияДанных;

КонецФункции

// {УП}
//
// Параметры:
//  ИмяРегистра	 - 	 - 
// 
// Возвращаемое значение:
//   - 
//
Функция ПоказателиРегистра(ИмяРегистра) Экспорт

	Если ПустаяСтрока(ИмяРегистра) Тогда
		Возврат Неопределено;
	КонецЕсли;

	Показатели = МеждународныйУчетСерверПовтИсп.Показатели(ИмяРегистра);
	
	Возврат Показатели;

КонецФункции
//{/УП}

#Область ОбновлениеИнформационнойБазы

// Обработчик обновления УП 2.0.4.6.
//  Заполняет предопределенные элементы справочника "НастройкиХозяйственныхОпераций".
//
Процедура ЗаполнитьПредопределенныеНастройкиХозяйственныхОпераций() Экспорт

	РеквизитыXML = Справочники.НастройкиХозяйственныхОпераций.ПолучитьМакет("НастройкиПредопределенныхЭлементов").ПолучитьТекст();
	РеквизитыТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(РеквизитыXML).Данные;
	
	СвязанныеДокументыXML = Справочники.НастройкиХозяйственныхОпераций.ПолучитьМакет("СвязанныеДокументы").ПолучитьТекст();
	СвязанныеДокументыТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(СвязанныеДокументыXML).Данные;
	
	Для каждого СтрокаТаблРеквизитов Из РеквизитыТаблица Цикл
		ID = СтрокаТаблРеквизитов.ID;
		Объект = Справочники.НастройкиХозяйственныхОпераций[ID].ПолучитьОбъект();
		ЗаполнитьЗначенияСвойств(Объект, СтрокаТаблРеквизитов);
		
		Приход = СтрокаТаблРеквизитов.Приход;
		Если ЗначениеЗаполнено(Приход) Тогда
			Объект.Приход = Перечисления.ТипыДанныхУчета[Приход];
		КонецЕсли;
		
		Расход = СтрокаТаблРеквизитов.Расход;
		Если ЗначениеЗаполнено(Расход) Тогда
			Объект.Расход = Перечисления.ТипыДанныхУчета[Расход];
		КонецЕсли;
		
		Хозоперация = СтрокаТаблРеквизитов.ХозяйственнаяОперация;
		Если ЗначениеЗаполнено(Хозоперация) Тогда
			Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации[Хозоперация];
		КонецЕсли;
		
		НайденныеСтроки = СвязанныеДокументыТаблица.НайтиСтроки(Новый Структура("OwnerID", ID));
		Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Если Объект.Документы.Найти(НайденнаяСтрока.ИмяДокумента, "ИмяДокумента") = Неопределено Тогда
				ЗаполнитьЗначенияСвойств(Объект.Документы.Добавить(), НайденнаяСтрока);
			КонецЕсли;
		КонецЦикла;
		
		Объект.Документы.Сортировать("ПредставлениеДокумента");
		
		//{УП}
		ПоказателиРегистра = ПоказателиРегистра(Объект.ИсточникДанных);
		Если ПоказателиРегистра <> Неопределено Тогда
			Объект.ПоказателиРегистра.Очистить();
			Для каждого Показатель Из ПоказателиРегистра Цикл
				НоваяСтрока = Объект.ПоказателиРегистра.Добавить();
				НоваяСтрока.Показатель = Показатель.Ключ;
				НоваяСтрока.Использование = Истина;
			КонецЦикла;
		КонецЕсли;
		
		Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.АмортизацияВнеоборотныхАктивов Тогда
			Объект.ПоказателиРегистра.Очистить();
			Строка = Объект.ПоказателиРегистра.Добавить();
			Строка.Показатель = Перечисления.ПоказателиАналитическихРегистров.Сумма;
			Строка.Использование = Истина;
		ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтражениеНДФЛ Тогда
			Объект.ПоказателиРегистра.Очистить();
			Строка = Объект.ПоказателиРегистра.Добавить();
			Строка.Показатель = Перечисления.ПоказателиАналитическихРегистров.Сумма;
			Строка.Использование = Истина;
		КонецЕсли;
		
		Объект.ПоказателиРегистра.Сортировать("Показатель");
		//{/УП}
		
		//ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
		Объект.Записать();
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли