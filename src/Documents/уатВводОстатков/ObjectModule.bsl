
#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)
	// Инициализация дополнительных свойств для проведения документа.
    уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
    
    // Инициализация данных документа.
    Документы.уатВводОстатков.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
    
    // Подготовка наборов записей.
    уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
    
    // Отражение в разделах учета.
	Если ВидОперации = Перечисления.уатВидыОперацийВводОстатков.ОперативныеДоходы Тогда
    	уатПроведение.ОтразитьДоходы(ДополнительныеСвойства, Движения, Отказ);
	ИначеЕсли ВидОперации = Перечисления.уатВидыОперацийВводОстатков.ОперативныеРасходы Тогда
		уатПроведение.ОтразитьРасходы(ДополнительныеСвойства, Движения, Отказ);
	ИначеЕсли ВидОперации = Перечисления.уатВидыОперацийВводОстатков.ОстаткиДСПодотчетныхЛиц Тогда
		уатПроведение_проф.ОтразитьОстаткиДСУПодотчетныхЛиц(ДополнительныеСвойства, Движения, Отказ);
	ИначеЕсли ВидОперации = Перечисления.уатВидыОперацийВводОстатков.ОстаткиДСВКассах
		ИЛИ ВидОперации = Перечисления.уатВидыОперацийВводОстатков.ОстаткиДСНаСчетах Тогда
		уатПроведение_проф.ОтразитьОстаткиДС(ДополнительныеСвойства, Движения, Отказ);
	КонецЕсли;
	
    // Запись наборов записей.
    уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);
    
    // Контроль возникновения отрицательного остатка.
    Документы.уатВводОстатков.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	// Инициализация дополнительных свойств для проведения документа
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	// Контроль
	Документы.уатВводОстатков.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	уатОбщегоНазначенияСервер.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ЭтотОбъект);
	
	уатОбщегоНазначения.ПроверкаЗаполненияПодразделения(Организация, Подразделение, Отказ, Заголовок);
	уатОбщегоНазначенияСервер.ПроверкаСоответствияМестонахожденияТС(ЭтотОбъект, Отказ, "Доходы", Заголовок);
	уатОбщегоНазначенияСервер.ПроверкаСоответствияМестонахожденияТС(ЭтотОбъект, Отказ, "Расходы", Заголовок);
	
	Если ВидОперации = Перечисления.уатВидыОперацийВводОстатков.ОперативныеДоходы
		ИЛИ ВидОперации = Перечисления.уатВидыОперацийВводОстатков.ОперативныеРасходы Тогда
		ТЧ = ?(ВидОперации = Перечисления.уатВидыОперацийВводОстатков.ОперативныеДоходы, Доходы, Расходы);
		Для Каждого ТекСтрока Из ТЧ Цикл
			Если ЗначениеЗаполнено(ТекСтрока.УдалитьПодразделение) И ТекСтрока.УдалитьПодразделение <> Подразделение Тогда
				ТекстСообщ = "В табличной части документа указано подразделение, отличное от подразделения в шапке документа (включить отображение колонки можно в настройках формы).
					|В текущей версии необходимо указывать Подразделение в шапке документа. Для каждого подразделения следует создавать отдельный документ.";
				уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстСообщ, Отказ, Заголовок);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
			
КонецПроцедуры

#КонецОбласти
