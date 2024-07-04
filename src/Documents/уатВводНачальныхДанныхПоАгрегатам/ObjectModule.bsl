
#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)
	// Инициализация дополнительных свойств для проведения документа.
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.уатВводНачальныхДанныхПоАгрегатам.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	Если ВидОперации = Перечисления.уатВидыОперацийВводОстатковПоАгрегатам.ВводОстатковПоСкладу Тогда
		уатПроведение.ОтразитьОстаткиАгрегатов(ДополнительныеСвойства, Движения, Отказ);
	Иначе
		уатПроведение.ОтразитьАгрегатыТС(ДополнительныеСвойства, Движения, Отказ);
	КонецЕсли;
	уатПроведение.ОтразитьИзносПробегШин(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей.
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ЗаписатьРеквизитыШин(Отказ);
	ЗаписатьРеквизитыАккумуляторов(Отказ);
	ЗаписатьРеквизитыПрочихАгрегатов(Отказ);
	
	// Контроль возникновения отрицательного остатка.
	Документы.уатВводНачальныхДанныхПоАгрегатам.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Заголовок = НСтр("en='Holding the document ';ru='Проведение документа '") + Ссылка;
	Если ВидОперации = Перечисления.уатВидыОперацийВводОстатковПоАгрегатам.УстановкаНаТС Тогда
		СтруктураШапкиДокумента = Новый Структура("ВидОперации, Организация");
	Иначе
		СтруктураШапкиДокумента = Новый Структура("ВидОперации, Организация, Склад");
	КонецЕСли;
	уатОбщегоНазначенияТиповые.уатПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект,СтруктураШапкиДокумента, Отказ, Заголовок);
	Если ВидОперации = Перечисления.уатВидыОперацийВводОстатковПоАгрегатам.УстановкаНаТС Тогда
		СтруктураПолей = Новый Структура("ТС, СерияНоменклатуры");
	Иначе
		СтруктураПолей = Новый Структура("СерияНоменклатуры");
	КонецЕСли;
	уатОбщегоНазначенияТиповые.уатПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Шины", СтруктураПолей, Отказ, Заголовок);
	уатОбщегоНазначенияТиповые.уатПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Аккумуляторы", СтруктураПолей, Отказ, 
																	Заголовок);
	уатОбщегоНазначенияТиповые.уатПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ПрочиеАгрегаты", СтруктураПолей, Отказ,
																	Заголовок);
	
	// проверка на дубли строк
	Если НЕ Отказ Тогда
		тблШины = Шины.Выгрузить().Скопировать();
		тблШины.Свернуть("СерияНоменклатуры");
		Если тблШины.Количество() < Шины.Количество() Тогда
			ТекстНСТР = НСтр("en='In tabular section ""Tires"" there are duplicate lines (duplicate of products and services series)!';ru='В табличной части ""Шины"" присутствуют повторяющиеся строки (дублирование серий номенклатуры)!'");
			уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ, Заголовок);
		КонецЕсли;
	КонецЕсли;
	Если НЕ Отказ Тогда
		тблАккумуляторы = Аккумуляторы.Выгрузить().Скопировать();
		тблАккумуляторы.Свернуть("СерияНоменклатуры");
		Если тблАккумуляторы.Количество() < Аккумуляторы.Количество() Тогда
			ТекстНСТР = НСтр("en='In tabular section ""Batteries"" there are duplicate lines (duplicate of products and services series)!';ru='В табличной части ""Аккумуляторы"" присутствуют повторяющиеся строки (дублирование серий номенклатуры)!'");
			уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ, Заголовок);
		КонецЕсли;
	КонецЕсли;
	Если НЕ Отказ Тогда
		тблПрочиеАгрегаты = ПрочиеАгрегаты.Выгрузить().Скопировать();
		тблПрочиеАгрегаты.Свернуть("СерияНоменклатуры");
		Если тблПрочиеАгрегаты.Количество() < ПрочиеАгрегаты.Количество() Тогда
			ТекстНСТР = НСтр("en='In tabular section ""Other car parts"" there are duplicate lines (duplicate products and services series)!';ru='В табличной части ""Прочие агрегаты"" присутствуют повторяющиеся строки (дублирование серий номенклатуры)!'");
			уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ, Заголовок);
		КонецЕсли;
	КонецЕсли;
	
	Если ВидОперации = Перечисления.уатВидыОперацийВводОстатковПоАгрегатам.ВводОстатковПоСкладу Тогда
		ШиныСостояние = ПроверяемыеРеквизиты.Найти("Шины.Состояние");
		Если Не ШиныСостояние = Неопределено Тогда 
			ПроверяемыеРеквизиты.Удалить(ШиныСостояние);
		КонецЕсли;
		АккумуляторыСостояние = ПроверяемыеРеквизиты.Найти("Аккумуляторы.Состояние");
		Если Не АккумуляторыСостояние = Неопределено Тогда 
			ПроверяемыеРеквизиты.Удалить(АккумуляторыСостояние);
		КонецЕсли;
	КонецЕсли;
	
	уатОбщегоНазначения.ПроверкаЗаполненияПодразделения(Организация, Подразделение, Отказ, Заголовок);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	уатОбщегоНазначенияСервер.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьРеквизитыШин(Отказ)
	Для каждого СтрШина Из Шины Цикл
		ШинаОбъект = СтрШина.СерияНоменклатуры.ПолучитьОбъект(); 
		ШинаОбъект.ПервоначальнаяСтоимость = СтрШина.Цена;
		ШинаОбъект.Валюта = ?(ЗначениеЗаполнено(ВалютаДокумента), ВалютаДокумента, 
								Константы.ВалютаРегламентированногоУчета.Получить());
		Попытка 
			ШинаОбъект.Записать();
		Исключение
			ТекстНСТР = НСтр("en='Failed to write the bus ""%1"" (%2)';ru='Не удалось записать шину ""%1"" (%2)'");
			ТекстНСТР = СтрШаблон(ТекстНСТР, ШинаОбъект.СерийныйНомер, ШинаОбъект.Модель);
			уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ);
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры 

Процедура ЗаписатьРеквизитыАккумуляторов(Отказ)
	Для каждого СтрАкк Из Аккумуляторы Цикл
		АккумОбъект = СтрАкк.СерияНоменклатуры.ПолучитьОбъект(); 
		АккумОбъект.ПервоначальнаяСтоимость = СтрАкк.Цена;
		АккумОбъект.Валюта = ?(ЗначениеЗаполнено(ВалютаДокумента), ВалютаДокумента, 
								Константы.ВалютаРегламентированногоУчета.Получить());
		Попытка 
			АккумОбъект.Записать();
		Исключение
			ТекстНСТР = НСтр("en='Unable to write the battery ""%1"" (%2)';ru='Не удалось записать аккумулятор ""%1"" (%2)'");
			ТекстНСТР = СтрШаблон(ТекстНСТР, АккумОбъект.СерийныйНомер, АккумОбъект.Модель);
			уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ);
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры 

Процедура ЗаписатьРеквизитыПрочихАгрегатов(Отказ)
	Для каждого ТекСтрока Из ПрочиеАгрегаты Цикл
		СпрОб = ТекСтрока.СерияНоменклатуры.ПолучитьОбъект(); 
		СпрОб.ПервоначальнаяСтоимость = ТекСтрока.Цена;
		СпрОб.Валюта = ?(ЗначениеЗаполнено(ВалютаДокумента), ВалютаДокумента, 
								Константы.ВалютаРегламентированногоУчета.Получить());
		Попытка 
			СпрОб.Записать();
		Исключение
			ТекстНСТР = НСтр("en='Failed to write car part ""%1"" (%2)';ru='Не удалось записать агрегат ""%1"" (%2)'");
			ТекстНСТР = СтрШаблон(ТекстНСТР, СпрОб.СерийныйНомер, СпрОб.Модель);
			уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ);
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры 

#КонецОбласти

