//@skip-check module-empty-method
Процедура ОбработкаЗаполненияЭТрН(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	// {УАТ}
	Если ДанныеЗаполнения <> Неопределено Тогда
		
		ТипЗначения = ТипЗнч(ДанныеЗаполнения);
		Если ТипЗначения = Тип("Структура") Тогда
			Если ДанныеЗаполнения.Свойство("ДокументыОснования") И ДокументОбъект <> Неопределено Тогда
				Для Каждого ДокументОснование Из ДанныеЗаполнения.ДокументыОснования Цикл
					уатОбменСГИСЭПД.ДобавитьДокументОснование(ДокументОбъект, ДокументОснование);
				КонецЦикла;
				ДанныеЗаполнения.Удалить("ДокументыОснования");
			КонецЕсли;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ДокументОбъект, ДанныеЗаполнения);
	КонецЕсли;
	// {/УАТ}
КонецПроцедуры

//@skip-check module-empty-method
Процедура ОбработкаЗаполненияЭСВ(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
КонецПроцедуры

//@skip-check module-empty-method
Процедура ОбработкаЗаполненияЭЗН(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
КонецПроцедуры

//@skip-check module-empty-method
Процедура ОбработкаЗаполненияЭЗЗ(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
КонецПроцедуры

//@skip-check module-empty-method
Процедура ОбработкаЗаполненияЭПЛ(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	// {УАТ}
	Если ДанныеЗаполнения <> Неопределено Тогда
		
		ТипЗначения = ТипЗнч(ДанныеЗаполнения);
		Если ТипЗначения = Тип("Структура") Тогда
			Если ДанныеЗаполнения.Свойство("ДокументыОснования") И ДокументОбъект <> Неопределено Тогда
				Для Каждого ДокументОснование Из ДанныеЗаполнения.ДокументыОснования Цикл
					уатОбменСГИСЭПД.ДобавитьДокументОснование(ДокументОбъект, ДокументОснование);
				КонецЦикла;
				ДанныеЗаполнения.Удалить("ДокументыОснования");
			КонецЕсли;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ДокументОбъект, ДанныеЗаполнения);
		ДокументОбъект.ТекущийТитул = Перечисления.ТипыЭлементовРегламентаЭДО.ЭПЛ_Титул1;
		ДокументОбъект.ВидДокумента = ЭлектронныеДокументыЭДО.ВидДокументаПоТипу(Перечисления.ТипыДокументовЭДО.ЭПЛ);
		уатОбменСГИСЭПД.ЗаполнитьУчастников(ДокументОбъект);
		уатОбменСГИСЭПД.ЗаполнитьИдентификациюФайлаОбмена(ДокументОбъект, ДанныеЗаполнения);
		
	КонецЕсли;
	// {/УАТ}
КонецПроцедуры

//@skip-check module-empty-method
Процедура ОбработкаЗаполненияЭДФ(ДокументОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
КонецПроцедуры

// Обработчик события получения входящего титула ЭПД.
//
// Параметры:
//   ДокументСсылка - ДокументСсылка.ЭлектроннаяТранспортнаяНакладная -
//			- ДокументСсылка.ЭлектроннаяСопроводительнаяВедомость -
//          - ДокументСсылка.ЭлектронныйЗаказНаряд - документ ЭПД.
//   ПолученныйТитул - ПеречислениеСсылка.ТипыЭлементовРегламентаЭДО - полученный титул документа.
//   ЭтоИсправление - Булево - признак исправления титула
//
//@skip-check module-empty-method
Процедура СобытиеПолучениеТитулаЭПД(ДокументСсылка, ПолученныйТитул, ЭтоИсправление) Экспорт
КонецПроцедуры

Функция ИмяПечатнойФормыЭТрН(ДатаДокумента) Экспорт

	Возврат "Документ.ЭлектроннаяТранспортнаяНакладная.ПФ_MXL_ТранспортнаяНакладная2116"
		
КонецФункции

Функция ВидФактическийАдресКонтрагента() Экспорт
	
	Возврат ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ФактАдресКонтрагента");
	
КонецФункции

Функция ИмяТипаБанковскиеСчетаОрганизации() Экспорт
	
	Возврат "СправочникСсылка.БанковскиеСчета";
	
КонецФункции